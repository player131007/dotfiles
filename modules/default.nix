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
  };

  flake.nixosModules = config.flake.modules.nixos;
}
