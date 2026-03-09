{ lib }:
{
  fromRoot = lib.path.append ./.;
  listModulesRecursive =
    let
      inherit (builtins)
        isPath
        readFileType
        concatMap
        filter
        ;
      inherit (lib) hasSuffix hasPrefix;

      expandFolders =
        arg:
        if !isPath arg || readFileType arg != "directory" then
          [ arg ]
        else
          lib.filesystem.listFilesRecursive arg;

      isModule =
        arg: !isPath arg || (hasSuffix ".nix" (toString arg) && !(hasPrefix "_" (baseNameOf arg)));
    in
    list:
    lib.pipe list [
      (concatMap expandFolders)
      (filter isModule)
    ];
}
