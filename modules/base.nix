{ self, ... }:
{
  flake.modules.nixos = {
    pc = self.modules.nixos.base;
    iso = self.modules.nixos.base;
  };
}
