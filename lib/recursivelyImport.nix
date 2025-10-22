{ lib }:
let
  inherit (builtins) isPath readFileType filter;
  inherit (lib) hasSuffix concatMap;

  expandFolders =
    something:
    if !isPath something || readFileType something != "directory" then
      [ something ]
    else
      lib.filesystem.listFilesRecursive something;
in
list: filter (elem: !isPath elem || hasSuffix ".nix" (toString elem)) (concatMap expandFolders list)
