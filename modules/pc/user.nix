{
  config,
  lib,
  sources,
  pkgs,
  ...
}:
let
  hjem = import sources.hjem { inherit pkgs; };

  username = "avery";
in
{
  imports = [
    hjem.nixosModules.hjem
    (lib.mkAliasOptionModule [ "my" "hjem" ] [ "hjem" "users" username ])
  ];

  services.userborn.enable = true;

  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    homeMode = "0700";
    hashedPasswordFile = "/persist/password/${username}";
    extraGroups = [
      "wheel"
      "libvirtd"
    ];
  };
  persist.at.oncedir.directories =
    let
      user = config.users.users.${username};
    in
    lib.singleton {
      directory = user.home;
      mode = user.homeMode;
      owner = user.name;
      group = user.group;
    };

  hjem = {
    linker = hjem.packages.smfh;
    clobberByDefault = true;
    users.${username}.enable = true;
  };
}
