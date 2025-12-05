let
  sources = import ./npins;
in
{
  pkgs ? import sources.nixpkgs { },
}:
let
  inherit (pkgs) lib;

  fenix = import sources.fenix {
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit pkgs lib;
  };
  mnw = import sources.mnw;

  toolchain = fenix.minimal.toolchain;
  scope = lib.makeScope pkgs.newScope (_: {
    rustPlatform_nightly = pkgs.makeRustPlatform {
      rustc = toolchain;
      cargo = toolchain;
    };
  });
in
lib.packagesFromDirectoryRecursive {
  inherit (scope) callPackage newScope;
  directory = ./pkgs/by-name;
}
// {
  neovim = mnw.lib.wrap { inherit pkgs mnw; } ./pkgs/nvim;
}
