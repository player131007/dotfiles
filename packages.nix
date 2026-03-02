let
  sources = import ./npins;
in
{
  pkgs ? import sources.nixpkgs { },
}:
let
  inherit (pkgs) lib;

  mnw = import sources.mnw;
in
lib.packagesFromDirectoryRecursive {
  inherit (pkgs) callPackage newScope;
  directory = ./pkgs/by-name;
}
// {
  neovim = mnw.lib.wrap { inherit pkgs mnw; } ./pkgs/nvim;
}
