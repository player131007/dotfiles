{
  config,
  lib,
  ...
}:
let
  username = "avery";
in
{
  imports = [
    (lib.mkAliasOptionModule [ "my" "user" ] [ "users" "users" username ])
    (lib.mkAliasOptionModule [ "my" "hjem" ] [ "hjem" "users" username ])
  ];

  services.userborn = {
    enable = true;
    importLegacyState = false;
  };

  hjem.clobberByDefault = true;

  users.mutableUsers = false;
  my.user = {
    isNormalUser = true;
    homeMode = "0700";
    hashedPasswordFile = "/.persist/password/${username}";
    extraGroups = [
      "wheel"
      "libvirtd"
    ];
  };
  persist.at.oncedir.directories =
    let
      user = config.my.user;
    in
    lib.singleton {
      directory = user.home;
      mode = user.homeMode;
      owner = user.name;
      group = user.group;
    };
}
