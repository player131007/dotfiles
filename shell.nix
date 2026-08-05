{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  wrappers ? import ./wrappers.nix { inherit sources pkgs; },
}:
pkgs.mkShellNoCC {
  allowSubstitutes = false; # Prevent a cache.nixos.org call every time

  packages = builtins.attrValues (removeAttrs wrappers [ "self" ]) ++ [
    pkgs.nixfmt
    pkgs.nixd
  ];
}
