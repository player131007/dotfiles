{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.93.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:Misterio77/nix-colors";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    let
      npins = import ./npins;
      npins-nixpkgs = import ./npins/fetch-with-nixpkgs.nix;

      module =
        {
          inputs,
          lib,
          self,
          ...
        }:
        {
          debug = true;
          systems = [ "x86_64-linux" ];

          _module.args = { inherit npins npins-nixpkgs; };
          flake = {
            inherit npins npins-nixpkgs;

            overlays = {
              default = lib.pipe ./overlays [
                builtins.readDir
                builtins.attrNames
                (map (x: import ./overlays/${x} { inherit self; }))
                lib.composeManyExtensions
              ];
            };
          };

          imports = [
            inputs.treefmt-nix.flakeModule
            ./modules
            ./hosts
          ];

          perSystem =
            { pkgs, inputs', ... }:
            {
              legacyPackages =
                let
                  rust-toolchain = inputs'.fenix.packages.minimal.toolchain;

                  scope-with-overrides = pkgs.lib.makeScope pkgs.newScope (self: {
                    rustPlatform_nightly = pkgs.makeRustPlatform {
                      rustc = rust-toolchain;
                      cargo = rust-toolchain;
                    };
                  });
                in
                pkgs.lib.packagesFromDirectoryRecursive {
                  inherit (scope-with-overrides) callPackage newScope;
                  directory = ./pkgs;
                };

              devShells.default = pkgs.mkShellNoCC {
                packages = [ pkgs.nixd ];
              };
              treefmt = {
                projectRootFile = "flake.nix";
                settings.global.excludes = [
                  "npins/default.nix"
                  "npins/sources.json"
                ];
                programs.nixfmt.enable = true;
              };
            };
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } module;
}
