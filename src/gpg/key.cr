require "../lib_gpg"
require "./subkey_iterator"

class GPG
  class Key
    def initialize(@handle : LibGPG::Key*)
    end

    def finalize
      LibGPG.key_release(@handle)
    end

    def to_unsafe
      @handle
    end

    def id
      subkeys.first.id
    end

    def fingerprint
      String.new(@handle.value.fpr)
    end

    def subkeys
      SubkeyIterator.new(@handle)
    end

    def flags
      @handle.value.flags
    end

    def ==(other : Key)
      fingerprint == other.fingerprint
    end
  end
end
