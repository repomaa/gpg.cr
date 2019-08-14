@[Link("gpgme")]
lib LibGPG
  type Context = Void*

  enum ErrorCode
    NO_ERROR = 0
    EOF = 16383
    CODE_DIM = 65536
  end

  alias Error = Int32

  ERROR_CODE_MASK = ErrorCode::CODE_DIM - 1

  enum PinentryMode
    Default
    Ask
    Cancel
    Error
    Loopback 
  end

  enum PubkeyAlgo
    RSA = 1
    RSA_E = 2
    RSA_S = 3
    ELG_E = 16
    DSA = 17
    ECC = 18
    ELG = 20
    ECDSA = 301
    ECDH = 302
    EDDSA = 303
  end

  enum Protocol
    OpenPGP  = 0
    CMS      = 1
    GPGCONF  = 2
    ASSUAN   = 3
    G13      = 4
    UISERVER = 5
    SPAWN    = 6
    DEFAULT  = 254
    UNKNOWN  = 255
  end

  enum Validity
    Unknown   = 0
    Undefined = 1
    Never     = 2
    Marginal  = 3
    Full      = 4
    Ultimate  = 5
  end

  @[Flags]
  enum EncryptFlags
    AlwaysTrust
    NoEncryptTo
    Prepare
    ExpectSign
    NoCompress
    Symmetric
  end

  type SigNotationFlags = UInt32

  type KeylistMode = UInt32

  struct TofuInfo
    next : TofuInfo*
    validity : UInt32
    policy : UInt32
    _rfu : UInt32
    signcount : UInt16
    encrcount : UInt16
    signfirst : UInt64
    signlast : UInt64
    encrfirst : UInt64
    encrlast : UInt64
    description : UInt8*
  end

  struct SigNotation
    next : SigNotation*
    name : UInt8*
    value : UInt8*
    name_len : Int32
    value_len : Int32
    flags : SigNotationFlags
    human_readable : UInt32
    critical : UInt32
    _unused : Int32
  end

  @[Flags]
  enum KeySignatureFlags
    Revoked
    Expired
    Invalid
    Exportable
  end

  struct KeySignature
    next : KeySignature*
    flags : KeySignatureFlags
    pubkey_algo : PubkeyAlgo
    keyid : UInt8*
    _keyid : StaticArray(UInt8, 17)
    timestamp : Int64
    expires : Int64
    status : Error
    class : UInt32
    uid : UInt8*
    name : UInt8*
    email : UInt8*
    comment : UInt8*
    sig_class : UInt32
    notations : SigNotation*
    _last_notation : SigNotation*
  end

  struct Subkey
    next : Subkey*
    info : UInt32
    pubkey_algo : PubkeyAlgo
    length : UInt32
    keyid : UInt8*
    _keyid : StaticArray(UInt8, 17)
    fpr : UInt8*
    timestamp : Int64
    expires : Int64
    card_number : UInt8*
    curve : UInt8*
    keygrip : UInt8*
  end

  @[Flags]
  enum UserIdFlags : UInt32
    Revoked
    Invalid
  end

  struct UserId
    next : UserId*
    validity : Validity
    uid : UInt8*
    name : UInt8*
    email : UInt8*
    comment : UInt8*
    signatures : KeySignature
    _last_keysig : KeySignature
    address : UInt8*
    tofu : TofuInfo
  end

  struct Key
    _refs : UInt32
    info : UInt32
    protocol : Protocol
    issuer_serial : UInt8*
    issuer_name : UInt8*
    chain_id : UInt8*
    owner_trust : Validity
    subkeys : Subkey*
    uids : UserId*
    _last_subkey : Subkey*
    _last_uid : UserId*
    keylist_mode : KeylistMode
    fpr : UInt8*
  end

  type Data = Void*

  fun check_version = gpgme_check_version(requested_version : UInt8*) : UInt8*
  fun new = gpgme_new(context : Context*) : Error
  fun release = gpgme_release(context : Context)

  fun strerror = gpgme_strerror(error : Error) : UInt8*
  fun error_from_errno = gpgme_error_from_errno(errno : Int32) : Error

  fun op_keyslist_start = gpgme_op_keylist_start(
    context : Context, pattern : UInt8*, secret_only : Int32
  ) : Error
  fun op_keylist_next = gpgme_op_keylist_next(context : Context, key : Key**) : Error
  fun op_keylist_end = gpgme_op_keylist_end(context : Context) : Error
  fun key_release = gpgme_key_release(key : Key*)

  fun data_new = gpgme_data_new(handle : Data*) : Error
  fun data_write = gpgme_data_write(handle : Data, buffer : Void*, size : UInt64) : Int64
  fun data_read = gpgme_data_read(handle : Data, buffer : Void*, size : UInt64) : Int64
  fun data_seek = gpgme_data_seek(handle : Data, offset : Int32, whence : Int32)
  fun data_release = gpgme_data_release(handle : Data)

  fun op_encrypt = gpgme_op_encrypt(
    context : Context, recipients : Key**, flags : EncryptFlags,
    plain : Data, cipher : Data
  ) : Error
  fun op_decrypt = gpgme_op_decrypt(
    context : Context, cipher : Data, plain : Data
  ) : Error

  fun signers_enum = gpgme_signers_enum(context : Context, index : Int32) : Key*
  fun signers_add = gpgme_signers_add(context : Context, key : Key*) : Error
  fun signers_clear = gpgme_signers_clear(context : Context)
  fun set_pinentry_mode = gpgme_set_pinentry_mode(context : Context, mode : PinentryMode) : Error
end
