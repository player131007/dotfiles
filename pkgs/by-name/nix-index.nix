{
  cacert,
  lib,
  makeBinaryWrapper,
  nix-index-unwrapped,
  util-linux,
  symlinkJoin,

  wrap_flags ? { },
}@args:
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

  nix-index = nix-index-unwrapped;
  wrap_flags = lib.attrsets.zipAttrsWith (_: builtins.concatLists) [
    default_wrap_flags
    (args.wrap_flags or { })
  ];
in
symlinkJoin {
  pname = "nix-index";
  inherit (nix-index) version;

  paths = [ nix-index ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  postBuild = lib.pipe wrap_flags [
    builtins.attrNames
    (map (file: /* bash */ ''
      rm $out/bin/${file}
      makeWrapper ${lib.getExe' nix-index file} $out/bin/${file} ${lib.escapeShellArgs wrap_flags.${file}}
    ''))
    lib.concatLines
  ];
}
