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
    (lib.mkAliasOptionModule
      [ "my" "tmpfiles" ]
      [ "systemd" "user" "tmpfiles" "users" username "rules" ]
    )
  ];

  _module.args = {
    inherit username;
    tmpfilesArg =
      let
        replacements = {
          "\t" = "\\x09";
          "\n" = "\\x0a";
          "\r" = "\\x0d";
          " " = "\\x20";
          "\\" = "\\x5c";
          "%" = "%%";
        };
      in
      builtins.replaceStrings (builtins.attrNames replacements) (builtins.attrValues replacements);

  };
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
      user = config.users.users.${username};
    in
    lib.singleton {
      directory = user.home;
      mode = user.homeMode;
      owner = user.name;
      group = user.group;
    };
}
