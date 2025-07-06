{ self, ... }:
{
  flake.modules.nixos."nixosConfigurations/tahari" =
    { modulesPath, ... }:
    {
      imports =
        builtins.attrValues {
          inherit (self.modules.nixos) iso resolved;
        }
        ++ [
          (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
        ];
    };
}
