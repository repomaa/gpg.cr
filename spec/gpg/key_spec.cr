require "../spec_helper"

describe GPG::Key do
  let(:gpg) do
    GPG.new.tap { |gpg| gpg.pinentry_mode = LibGPG::PinentryMode::Loopback }
  end

  context "secret key" do
    subject(:key) { gpg.list_keys(secret_only: true).first }

    it "has correct flags" do
      expect(key.can_encrypt?).to be_true
      expect(key.can_sign?).to be_true
      expect(key.can_certify?).to be_true
      expect(key.secret?).to be_true
    end
  end

  context "public key" do
    subject(:key) do
      gpg.list_keys(PUBLIC_KEYS.sample).first
    end

    it "has correct flags" do
      expect(key.can_encrypt?).to be_true
      expect(key.can_sign?).to be_true
      expect(key.can_certify?).to be_true
      expect(key.can_authenticate?).to be_true
    end
  end
end
