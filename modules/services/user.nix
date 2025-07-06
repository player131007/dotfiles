{ inputs, self, ... }:
{
  flake.modules.nixos.pc = {
    imports = [
      inputs.nix-maid.nixosModules.default
    ];
    users.mutableUsers = false;
    users.users.player131007 = {
      isNormalUser = true;
      maid.imports = builtins.attrValues {
        inherit (self.modules.maid) pc programs;
      };
    };
  };
}
