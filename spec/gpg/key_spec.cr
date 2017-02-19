require "../spec_helper"

describe GPG::Key do
  let(:gpg) do
    GPG.new.tap { |gpg| gpg.pinentry_mode = LibGPG::PinentryMode::Loopback }
  end

  context "secret key" do
    subject(:key) { gpg.list_keys(secret_only: true).first }

    it "has correct flags" do
      expect(key.flags).to eq(
        LibGPG::KeyFlags::CanEncrypt |
        LibGPG::KeyFlags::CanSign |
        LibGPG::KeyFlags::CanCertify |
        LibGPG::KeyFlags::Secret
      )
    end
  end

  context "public key" do
    subject(:key) { gpg.list_keys(PUBLIC_KEYS.sample).first }

    it "has correct flags" do
      expect(key.flags).to eq(
        LibGPG::KeyFlags::CanEncrypt |
        LibGPG::KeyFlags::CanSign |
        LibGPG::KeyFlags::CanCertify
      )
    end
  end
end
