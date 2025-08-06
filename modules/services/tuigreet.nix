{
  flake.modules.nixos.pc =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      services.greetd = {
        enable = true;
        vt = 2;
        settings.default_session.command = "${lib.getExe pkgs.greetd.tuigreet} -t -d -r --remember-user-session --asterisks --user-menu";
      };

      preservation.preserveAt.${config.stuff.persistOnceDir}.directories =
        let
          inherit (config.users.users.greeter) name group;
        in
        lib.singleton {
          directory = "/var/cache/tuigreet";
          user = name;
          inherit group;
        };
    };
}
