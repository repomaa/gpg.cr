require "../lib_gpg"
require "./exception"

class GPG
  class Data < IO
    @handle : LibGPG::Data

    def initialize
      gpg_error = LibGPG.data_new(out handle)
      Exception.raise_if_error(gpg_error)
      @handle = handle
    end

    def self.new(slice : Slice)
      new.tap do |data|
        data.write(slice)
      end
    end

    def self.new(string : String)
      new(string.to_slice)
    end

    def finalize
      LibGPG.data_release(@handle)
    end

    def to_unsafe
      @handle
    end

    def write(slice)
      bytes_written = LibGPG.data_write(@handle, slice, slice.size)
      Exception.raise_from_errno if bytes_written == -1
      bytes_written
    end

    def read(slice)
      bytes_read = LibGPG.data_read(@handle, slice, slice.size)
      Exception.raise_from_errno if bytes_read == -1
      bytes_read
    end

    def rewind
      LibGPG.data_seek(@handle, 0, 0)
    end
  end
end
