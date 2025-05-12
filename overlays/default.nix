{ lib, ... }:
{
  flake.overlays.default = lib.pipe ./. [
    builtins.readDir
    builtins.attrNames
    (builtins.filter (f: f != "default.nix"))
    (map (lib.path.append ./.))
    (map import)
    lib.composeManyExtensions
  ];
}
