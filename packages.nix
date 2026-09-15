{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:
let
  inherit (pkgs) lib;
in
lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./pkgs/by-name;
}
