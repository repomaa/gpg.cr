require "./spec_helper"
require "./gpg/*"

describe GPG do
  describe ".new" do
    it "succeeds without error" do
      GPG.new
    end
  end

  subject(:gpg) { described_class.new }

  describe "#list_keys" do
    it "returns a key iterator" do
      expect(gpg.list_keys).to be_a(Iterator(GPG::Key))
    end

    it "returns the correct amount of results" do
      count = gpg.list_keys.size
      expect(count).to eq(3)
    end

    it "contains the correct keys" do
      expected_fingerprints = [SECRET_KEY] + PUBLIC_KEYS
      gpg.list_keys.map(&.fingerprint).each do |fingerprint|
        expect(expected_fingerprints.includes?(fingerprint)).to be_true
      end
    end
  end

  describe "#encrypt" do
    it "produces correct ciphertext" do
      secret_key = gpg.list_keys(secret_only: true).first
      cipher = gpg.encrypt("foobar", secret_key)
      expect(decrypt(cipher)).to eq("foobar")
    end
  end

  describe "#decrypt" do
    it "produces correct plaintext" do
      cipher = encrypt("foobar", SECRET_KEY)
      expect(gpg.decrypt(cipher)).to eq("foobar")
    end
  end

  describe "#signers" do
    it "is empty by default" do
      expect(gpg.signers.empty?).to be_true
    end

    it "returns a key iterator" do
      expect(gpg.signers).to be_a(Iterator(GPG::Key))
    end
  end

  def decrypt(cipher)
    Process.run("gpg", ["-d"]) do |io|
      io.input << cipher
      io.input.close
      io.output.gets_to_end
    end
  end

  def encrypt(plain, recipient)
    Process.run("gpg", ["-e", "-r", recipient]) do |io|
      io.input << plain
      io.input.close
      io.output.gets_to_end
    end
  end
end
