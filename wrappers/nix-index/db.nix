# same as upstream, but works with fork
{
  stdenvNoCC,

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

  buildCommand = /* bash */ ''
    cd ${nix-index-cache}
    nix-index ${extraArgs} --path-cache --db=$out
  '';
}
