{
  cacert,
  lib,
  makeBinaryWrapper,
  nix-index-unwrapped,
  util-linux,
  symlinkJoin,

  wrap_flags ? { },
}:
let
  _wrap_flags = wrap_flags;
in
let
  default_wrap_flags = {
    command-not-found = [
      "--inherit-argv0"
      "--prefix"
      "PATH"
      ":"
      "${util-linux.bin}/bin"
    ];

    nix-index = [
      "--inherit-argv0"
      "--set"
      "SSL_CERT_FILE"
      "${cacert}/etc/ssl/certs/ca-bundle.crt"
    ];
  };

  wrap_flags = lib.attrsets.zipAttrsWith (_: builtins.concatLists) [
    default_wrap_flags
    _wrap_flags
  ];
in
symlinkJoin {
  pname = "nix-index";
  inherit (nix-index-unwrapped) version;

  paths = [ nix-index-unwrapped ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild = lib.pipe wrap_flags [
    builtins.attrNames
    (map (file: /* bash */ ''
      rm $out/bin/${file}
      makeWrapper ${lib.getExe' nix-index-unwrapped file} $out/bin/${file} ${
        lib.escapeShellArgs wrap_flags.${file}
      }
    ''))
    lib.concatLines
  ];
}
