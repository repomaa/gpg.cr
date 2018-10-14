require "spec2"
require "../src/gpg"

include Spec2::GlobalDSL

ENV["GNUPGHOME"] = File.expand_path("../gpg_home", __FILE__)

PUBLIC_KEYS = [
  "CC7BD43A315EBC373F9A1F2EEFEB16CB1C8952C5",
]

if ENV.has_key?("POPULATE_KEYRING")
  Dir.mkdir_p(ENV["GNUPGHOME"], 0o700)

  system("gpg", %w(--no-tty --batch --gen-key --yes spec/gpg_test_key_params))
  system("gpg", ["--recv-keys", "--keyserver", "keys.gnupg.net"] + PUBLIC_KEYS)
end

SECRET_KEY = `gpg --with-colons --list-secret-keys`.split("\n")[1].split(":")[9]
