require "spec2"
require "../src/gpg"

include Spec2::GlobalDSL

ENV["GNUPGHOME"] = File.expand_path("../gpg_home", __FILE__)

PUBLIC_KEYS = [
  "26DCD9B1C4192A20C856D3A04D9F310E17204540",
  "5ABF9DA3611C7BF52F7D1E205AEA4737C7376714"
]

if ENV.has_key?("POPULATE_KEYRING")
  system(
    "gpg",
    [
      "--batch", "--passphrase", "", "--quick-generate-key",
      "Test test@example.com"
    ]
  )
  system("gpg", ["--recv-keys"] + PUBLIC_KEYS)
end

SECRET_KEY = `gpg --with-colons --list-secret-keys | awk -F: '$1 == "fpr" {print $10;}' | head -n1`.chomp
