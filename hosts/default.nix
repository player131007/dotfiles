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
        system = null;
        modules = (args.modules or [ ]) ++ [
          ./${host}
          { networking.hostName = lib.mkDefault host; }
          self.nixosModules.base
        ];
      }
      // builtins.removeAttrs args [ "modules" ]
    );
in
{
  flake.nixosConfigurations = lib.mapAttrs mkHost {
    unora = {
      modules = [
        inputs.nix-index-database.nixosModules.nix-index
        inputs.lix-module.nixosModules.default
        inputs.preservation.nixosModules.default
        inputs.home-manager.nixosModules.default
        self.modules.generic.npins
        self.modules.generic.otherpkgs
        self.nixosModules.oh-my-posh
        (
          { otherpkgs, ... }:
          {
            nixpkgs.overlays = [ self.overlays.default ];
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit otherpkgs; };
              users.player131007 = {
                imports = [
                  (self + "/users/player131007")
                  self.modules.generic.npins
                ];
              };
            };
          }
        )
      ];
    };

    tahari = {
      modules = [
        inputs.lix-module.nixosModules.default
      ];
    };
  };
}
