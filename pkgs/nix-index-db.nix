# same as upstream, but works with fork
{
  stdenvNoCC,

  nix-index,
  nix-index-cache,

  extraArgs ? "--compression=9",
}:
stdenvNoCC.mkDerivation {
  name = "nix-index-db";

  nativeBuildInputs = [
    nix-index
    nix-index-cache
  ];

  __structuredAttrs = true;
  unsafeDiscardReferences.out = true;

  buildCommand = /* bash */ ''
    cd ${nix-index-cache}
    nix-index ${extraArgs} --path-cache --db=$out
  '';
}
