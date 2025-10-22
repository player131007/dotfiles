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
                    (
                      { lib, pkgs, ... }:
                      {
                        networking.hostName = lib.mkDefault hostname;

                        _module.args = {
                          my = {
                            lib = myLib;
                            pkgs = self.legacyPackages.${pkgs.stdenv.hostPlatform.system};
                          };
                        };
                      }
                    )
                  ];

                specialArgs = args.specialArgs or { } // {
                  inherit inputs;
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
