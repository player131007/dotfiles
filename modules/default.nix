{
  config,
  inputs,
  self,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules = {
    nixos = {
      oh-my-posh = ./nixos/oh-my-posh.nix;
      base = ./nixos/base.nix;
    };

    homeManager = {
      ringboard = ./hm/ringboard.nix;
    };

    generic = {
      base24 = {
        imports = [
          "${inputs.nix-colors}/module/colorscheme.nix"
          (import ./generic/theme.nix inputs.nix-colors)
        ];
      };
      npins =
        { pkgs, ... }:
        {
          _module.args.npins = self.npins-nixpkgs pkgs;
        };
    };
  };

  flake.nixosModules = config.flake.modules.nixos;
}
