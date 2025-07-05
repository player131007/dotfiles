{ inputs, ... }:
{
  flake.modules.nixos.pc = inputs.nix-index-database.nixosModules.nix-index;
}
