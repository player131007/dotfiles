{ inputs, self, ... }:
{
  flake.modules.nixos.pc =
    { config, lib, ... }:
    {
      imports = [
        inputs.nix-maid.nixosModules.default
      ];
      users.mutableUsers = false;
      users.users.player131007 = {
        isNormalUser = true;
        homeMode = "0700";
        hashedPasswordFile = "/persist/password/player131007";
        maid.imports = builtins.attrValues {
          inherit (self.modules.maid) pc programs;
        };
      };

      preservation.preserveAt.${config.stuff.persistOnceDir}.directories =
        let
          user = config.users.users.player131007;
        in
        lib.singleton {
          directory = user.home;
          mode = user.homeMode;
          user = user.name;
          inherit (user) group;
        };
    };
}
