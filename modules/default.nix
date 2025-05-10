{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  flake.modules = {
    nixos = {
      base = ./nixos/base.nix;
      oh-my-posh = ./nixos/oh-my-posh.nix;
    };

    generic = {
      base24 = {
        imports = [
          "${inputs.nix-colors}/module/colorscheme.nix"
          (import ./generic/theme.nix inputs.nix-colors)
        ];
      };
    };
  };

  flake.nixosModules = config.flake.modules.nixos;
}
