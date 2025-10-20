{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";
    preservation.url = "github:nix-community/preservation";
    nix-maid.url = "github:viperML/nix-maid";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = lib.genAttrs systems;
    in
    {
      legacyPackages = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          rust-toolchain = inputs.fenix.packages.${system}.minimal.toolchain;
          scope = lib.makeScope pkgs.newScope (_: {
            rustPlatform_nightly = pkgs.makeRustPlatform {
              rustc = rust-toolchain;
              cargo = rust-toolchain;
            };
          });
        in
        lib.packagesFromDirectoryRecursive {
          inherit (scope) callPackage newScope;
          directory = ./pkgs/by-name;
        }
        // {
          neovim = inputs.mnw.lib.wrap {
            inherit pkgs;
            inherit (inputs) mnw;
          } ./pkgs/nvim;
        }
      );

      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          nvim = pkgs.mkShellNoCC {
            packages = [
              self.legacyPackages.${system}.neovim.devMode
              pkgs.npins
            ];
          };
        }
      );
    };
}
