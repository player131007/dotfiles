{
  config,
  lib,
  sources,
  pkgs,
  username,
  ...
}:
let
  hjem = import sources.hjem { inherit pkgs; };
in
{
  imports = [
    hjem.nixosModules.hjem
    (lib.mkAliasOptionModule [ "my" "hjem" ] [ "hjem" "users" username ])
    (lib.mkAliasOptionModule [ "my" "tmpfiles" ] [ "systemd" "user" "tmpfiles" "users" username ])
  ];

  users.mutableUsers = false;
  users.users.${username} = {
    isNormalUser = true;
    homeMode = "0700";
    hashedPasswordFile = "/persist/password/${username}";
    extraGroups = [ "wheel" ];
  };
  persist.at.oncedir.directories =
    let
      user = config.users.users.${username};
    in
    [
      {
        directory = user.home;
        mode = user.homeMode;
        owner = user.name;
        group = user.group;
      }

      (lib.mkIf config.services.accounts-daemon.enable "/var/lib/AccountsService")
    ];

  hjem = {
    linker = hjem.packages.smfh;
    users.${username}.enable = true;
  };

  services.userborn.enable = true;
  services.accounts-daemon.enable = true;
}
