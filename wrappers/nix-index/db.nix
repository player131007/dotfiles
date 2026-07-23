# same as upstream, but works with fork
{
  stdenvNoCC,
  cacert,

  nix-index,
  nix-index-cache,

  extraArgs ? "--compression=9",
  name ? "nix-index-db",
}:
stdenvNoCC.mkDerivation {
  inherit name;

  nativeBuildInputs = [
    nix-index
    nix-index-cache
  ];

  strictDeps = true;
  __structuredAttrs = true;
  unsafeDiscardReferences.out = true;

  env = {
    # not used, but nix-index will error if there's no cert
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  buildCommand = /* bash */ ''
    cd ${nix-index-cache}
    nix-index ${extraArgs} --path-cache --db=$out
  '';
}
