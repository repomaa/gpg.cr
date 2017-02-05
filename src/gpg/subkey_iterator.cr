require "../lib_gpg"
require "./subkey"

class GPG
  class SubkeyIterator
    include Iterator(Subkey)

    @current_subkey : LibGPG::Subkey*

    def initialize(@handle : LibGPG::Key*)
      @current_subkey = @handle.value.subkeys
    end

    def next
      subkey = @current_subkey
      return stop if subkey.null?
      @current_subkey = subkey.value.next
      Subkey.new(subkey)
    end
  end
end
