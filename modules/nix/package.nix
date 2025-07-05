{ inputs, ... }:
{
  flake.modules.nixos.base = inputs.lix-module.nixosModules.default;
}
