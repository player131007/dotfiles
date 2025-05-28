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

    homeManager = {
      ringboard = moduleWithSystem (
        { config }:
        { lib, ... }:
        {
          imports = [ ./hm/ringboard.nix ];

          programs.ringboard = {
            package = lib.mkDefault config.legacyPackages.ringboard-server;
            x11.package = lib.mkDefault config.legacyPackages.ringboard-x11;
            wayland.package = lib.mkDefault config.legacyPackages.ringboard-wayland;
          };
        }
      );
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
