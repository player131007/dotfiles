{
  config,
  inputs,
  ...
}: {
  imports = [inputs.flake-parts.flakeModules.modules];

  flake.modules = {
    nixos = {
      base = ./nixos/base.nix;
      oh-my-posh = ./nixos/oh-my-posh.nix;
      dwl = ./nixos/dwl.nix;
    };

    generic = {
      theme = {
        # same module as homeManagerModule
        imports = [inputs.base16.nixosModule];
        scheme = ./generic/theme/rose-pine.yaml;
      };
    };
  };

  flake.nixosModules = config.flake.modules.nixos;
}
