{
  inputs,
  self,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;
in
{
  flake.nixosConfigurations = {
    laptop = lib.nixosSystem {
      modules = [
        ./laptop
        inputs.lix-module.nixosModules.default
        inputs.impermanence.nixosModule
        inputs.nixvirt.nixosModules.default
        self.modules.generic.npins
        self.modules.generic.base24
        self.nixosModules.base
        {
          nixpkgs.overlays = [ self.overlays.default ];
        }
      ];
    };

    image = lib.nixosSystem {
      modules = [
        ./iso.nix
        inputs.lix-module.nixosModules.default
        self.nixosModules.base
      ];
    };
  };
}
