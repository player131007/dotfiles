{ lib, self, ... }:
{
  flake.overlays.default = lib.pipe ./. [
    builtins.readDir
    builtins.attrNames
    (builtins.filter (f: f != "default.nix"))
    (map (x: import ./${x} { inherit (self) npins; }))
    lib.composeManyExtensions
  ];
}
