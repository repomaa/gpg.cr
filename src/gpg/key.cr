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

    {% for attribute, i in %i[revoked expired disabled invalid can_encrypt can_sign can_certify secret can_authenticate is_qualified] %}
      def {{attribute.id}}?
        ((@handle.value.info >> {{i}}) & 0x1) != 0
      end
    {% end %}

    def ==(other : Key)
      fingerprint == other.fingerprint
    end
  end
end
