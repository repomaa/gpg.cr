require "../lib_gpg"
require "./key"
require "./exception"

class GPG
  class KeyIterator
    include Iterator(Key)

    def initialize(@handle : LibGPG::Context)
    end

    def finalize
      LibGPG.op_keylist_end(@handle)
    end

    def next
      gpg_error = LibGPG.op_keylist_next(@handle, out key_pointer)
      return stop if Exception.error_code(gpg_error) == LibGPG::ErrorCode::EOF
      Exception.raise_if_error(gpg_error)
      Key.new(key_pointer)
    end
  end
end
