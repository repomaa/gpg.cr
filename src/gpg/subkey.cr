class GPG
  class Subkey
    def initialize(@handle : LibGPG::Subkey*)
    end

    def id
      String.new(@handle.value.keyid)
    end

    def to_unsafe
      @handle
    end
  end
end
