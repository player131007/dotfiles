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
  ++ (
    ./wrappers
    |> readDir
    |> mapAttrs (name: type: if type != "directory" then lib.strings.removeSuffix ".nix" name else name)
    |> attrValues
    |> filter (name: name != "self")
    |> map (name: wrappers.${name})
  );
}
