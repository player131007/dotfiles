{ self, ... }:
{
  flake.modules.nixos."nixosConfigurations/unora".imports = builtins.attrValues {
    inherit (self.modules.nixos)
      efi
      pc
      nvidia
      programs
      resolved
      ;
  };
}
