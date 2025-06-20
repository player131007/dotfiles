{
  config,
  inputs,
  self,
  moduleWithSystem,
  lib,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules = {
    nixos = {
      oh-my-posh = ./nixos/oh-my-posh.nix;
      base = ./nixos/base.nix;
    };

    generic = {
      base24 = {
        imports = [
          "${inputs.nix-colors}/module/colorscheme.nix"
          (lib.modules.importApply ./generic/theme.nix inputs.nix-colors)
        ];
      };
      npins =
        { pkgs, ... }:
        {
          _module.args.npins = self.npins-nixpkgs pkgs;
        };
      otherpkgs = moduleWithSystem (
        { config }:
        {
          _module.args.otherpkgs = config.legacyPackages;
        }
      );
    };
  };

  flake.nixosModules = config.flake.modules.nixos;
}
