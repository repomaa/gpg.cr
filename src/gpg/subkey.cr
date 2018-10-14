class GPG
  class Subkey
    def initialize(@handle : LibGPG::Subkey*)
    end

    def id
      String.new(@handle.value.keyid)
    end

    {% for attribute, i in %i[revoked expired disabled invalid can_encrypt can_sign can_certify secret can_authenticate is_qualified is_cardkey is_de_vs] %}
      def {{attribute.id}}?
        ((@handle.value.info >> {{i}}) & 0x1) != 0
      end
    {% end %}

    def to_unsafe
      @handle
    end
  end
end
