require "../spec_helper"

describe GPG::Signers do
  subject(:signers) { gpg.signers }

  let(:gpg) do
    GPG.new.tap { |gpg| gpg.pinentry_mode = LibGPG::PinentryMode::Loopback }
  end

  let(:secret_key) { gpg.list_keys(secret_only: true).first }

  describe "#size" do
    it "is 0 by default" do
      expect(signers.size).to eq(0)
    end
  end

  describe "#<<" do
    it "increases size by 1" do
      signers << secret_key
      expect(signers.size).to eq(1)
    end
  end

  describe "#to_a" do
    it "returns expected keys" do
      signers << secret_key
      expect(signers.to_a).to eq([secret_key])
    end
  end
end
