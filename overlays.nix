{lib, ...}: {
  flake.overlays.default = lib.pipe ./overlays [
    builtins.readDir
    builtins.attrNames
    (map (lib.path.append ./overlays))
    (map import)
    lib.composeManyExtensions
  ];
}
