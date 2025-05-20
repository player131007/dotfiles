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
        inputs.home-manager.nixosModules.default
        self.modules.generic.npins
        self.modules.generic.base24
        self.nixosModules.base
        {
          nixpkgs.overlays = [ self.overlays.default ];
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.player131007 = {
              imports = [
                (self + "/users/player131007")
                self.modules.generic.base24
                self.modules.generic.npins
              ];
            };
          };
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
