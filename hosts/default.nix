{
  inputs,
  self,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;
  mkHost =
    host: args:
    lib.nixosSystem (
      {
        modules = (args.modules or [ ]) ++ [
          ./${host}
          { networking.hostName = lib.mkDefault host; }
          self.nixosModules.base
        ];
      }
      // builtins.removeAttrs args [ "modules" ]
    );

  hosts = {
    unora = {
      modules = [
        inputs.lix-module.nixosModules.default
        inputs.impermanence.nixosModule
        inputs.nixvirt.nixosModules.default
        inputs.home-manager.nixosModules.default
        self.modules.generic.npins
        self.modules.generic.base24
        self.nixosModules.oh-my-posh
        {
          nixpkgs.overlays = builtins.attrValues self.overlays;
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

    tahari = {
      modules = [
        inputs.lix-module.nixosModules.default
      ];
    };
  };
in
{
  flake.nixosConfigurations = lib.mapAttrs mkHost hosts;
}
