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
        self.nixosModules.base
        self.nixosModules.oh-my-posh
        self.nixosModules.dwl
        self.modules.generic.theme
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
