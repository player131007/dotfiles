{
  config,
  lib,
  inputs,
  pkgs,
  my,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.default
    (lib.mkAliasOptionModule [ "my" "hjem" ] [ "hjem" "users" my.name ])
    (lib.mkAliasOptionModule [ "my" "tmpfiles" ] [ "systemd" "user" "tmpfiles" "users" my.name ])
  ];

  users.mutableUsers = false;
  users.users.${my.name} = {
    isNormalUser = true;
    homeMode = "0700";
    hashedPasswordFile = "/persist/password/${my.name}";
    extraGroups = [ "wheel" ];
  };
  persist.at.oncedir.directories =
    let
      user = config.users.users.${my.name};
    in
    lib.singleton {
      directory = user.home;
      mode = user.homeMode;
      owner = user.name;
      group = user.group;
    };

  hjem = {
    linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
    users.${my.name}.enable = true;
  };

  services.userborn.enable = true;
}
