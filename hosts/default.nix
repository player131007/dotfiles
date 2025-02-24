{
  inputs,
  self,
  ...
}: let
  inherit (inputs.nixpkgs) lib;
in {
  flake.nixosConfigurations = {
    laptop = lib.nixosSystem {
      modules = [
        ./laptop
        inputs.lix-module.nixosModules.default
        inputs.impermanence.nixosModule
        inputs.base16.nixosModule
        inputs.nixvirt.nixosModules.default
        self.nixosModules.base
        self.nixosModules.oh-my-posh
        self.nixosModules.dwl
        {
          virtualisation.libvirtd.package = inputs.nixpkgs-libvirt.legacyPackages.x86_64-linux.libvirt;
          nixpkgs.overlays = [self.overlays.default];
        }
      ];
    };

    image = lib.nixosSystem {
      modules = [
        ./iso.nix
        self.nixosModules.base
      ];
    };
  };
}
