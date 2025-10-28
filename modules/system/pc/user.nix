{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.default
  ];

  users.mutableUsers = false;
  users.users.player131007 = {
    isNormalUser = true;
    homeMode = "0700";
    hashedPasswordFile = "/persist/password/player131007";
    extraGroups = [ "wheel" ];
  };
  persist.at.oncedir.directories =
    let
      user = config.users.users.player131007;
    in
    lib.singleton {
      directory = user.home;
      mode = user.homeMode;
      owner = user.name;
      group = user.group;
    };

  hjem = {
    linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
    users.player131007.enable = true;
  };

  services.userborn.enable = true;
}
