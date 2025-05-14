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
      base = ./nixos/base.nix;
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
          _module.args.npins =
            builtins.removeAttrs (pkgs.callPackage "${self}/npins/fetch-with-nixpkgs.nix" { })
              [
                "override"
                "overrideDerivation"
              ];
        };
    };
  };

  flake.nixosModules = config.flake.modules.nixos;
}
