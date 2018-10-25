require "errno"
require "../lib_gpg"

class GPG
  class Exception < ::Exception
    def initialize(gpg_error)
      message = String.new(LibGPG.strerror(gpg_error))
      super(message)
    end

    def self.raise_if_error(gpg_error)
      return if error_code(gpg_error) == LibGPG::ErrorCode::NO_ERROR
      raise new(gpg_error) 
    end

    @[AlwaysInline]
    def self.error_code(gpg_error)
      code = gpg_error.as(Int32) & LibGPG::ERROR_CODE_MASK.to_i
      LibGPG::ErrorCode.from_value?(code)
    end

    def self.raise_from_errno
      gpg_error = LibGPG.error_from_errno(Errno.value)
      raise new(gpg_error)
    end
  end
end
