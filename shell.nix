{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  wrappers ? import ./wrappers.nix { inherit sources pkgs; },
}:
let
  inherit (builtins)
    attrValues
    filter
    mapAttrs
    readDir
    ;
  inherit (pkgs) lib;
in
pkgs.mkShellNoCC {
  allowSubstitutes = false; # Prevent a cache.nixos.org call every time

  packages = [
    pkgs.nixfmt
    pkgs.nixd
  ]
  ++ lib.pipe ./wrappers [
    readDir
    (mapAttrs (k: v: if v != "directory" then lib.strings.removeSuffix ".nix" k else k))
    attrValues
    (filter (name: name != "self"))
    (map (name: wrappers.${name}))
  ];
}
