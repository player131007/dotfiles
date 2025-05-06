{lib, ...}: {
  flake.overlays.default = lib.pipe ./overlays [
    lib.filesystem.listFilesRecursive
    (map import)
    lib.composeManyExtensions
  ];
}
