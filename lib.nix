{ lib }:
{
  fromRoot = lib.path.append ./.;
  listModulesRecursive =
    path:
    path
    |> lib.fileset.fileFilter (file: file.hasExt "nix" && !lib.strings.hasPrefix "_" file.name)
    |> lib.fileset.toList;
}
