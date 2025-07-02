{
  config,
  inputs,
  self,
  moduleWithSystem,
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
