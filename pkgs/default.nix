let
  sources = import ../npins;
in
{
  pkgs ? import sources.nixpkgs { config.allowUnfree = true; },
}:
let
  inherit (pkgs) lib;
in
lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./by-name;
}
