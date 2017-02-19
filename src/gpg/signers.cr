require "./key"

class GPG
  class Signers
    include Iterator(Key)

    @index : Int32

    def initialize(@handle : LibGPG::Context)
      @index = 0
    end

    def next
      key_handle = LibGPG.signers_enum(@handle, @index)
      return stop if key_handle.null?
      @index += 1
      Key.new(key_handle)
    end

    def <<(key)
      error = LibGPG.signers_add(@handle, key)
      Exception.raise_if_error(error)
      key
    end

    def push(key)
      self << key
    end

    def clear
      LibGPG.signers_clear(@handle)
    end

    def rewind
      @index = 0
    end

    def empty?
      size == 0
    end
  end
end
