{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mnw.url = "github:Gerg-L/mnw";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
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

      myLib = import ./lib { inherit lib; };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSystem = lib.genAttrs systems;
    in
    {
      nixosConfigurations =
        let
          mkHost =
            hostname: args:
            lib.nixosSystem (
              args
              // {
                modules =
                  args.modules or [ ]
                  ++ myLib.recursivelyImport [
                    ./modules/system/base
                    ./modules/programs/base

                    ./modules/hosts/${hostname}
                    { networking.hostName = lib.mkDefault hostname; }
                  ];

                specialArgs = args.specialArgs or { } // {
                  inherit inputs;
                  my.lib = myLib;
                };
              }
            );
        in
        lib.mapAttrs mkHost {
          tahari = {
            modules = myLib.recursivelyImport [
              ./modules/system/iso
            ];
          };

          unora = {
            modules = myLib.recursivelyImport [
              ./modules/programs
              ./modules/system/pc
              { system.stateVersion = "23.05"; }
            ];
          };
        };

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
