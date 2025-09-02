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
        settings.default_session.command = "${lib.getExe pkgs.tuigreet} -t -d -r --remember-user-session --asterisks --user-menu";
        useTextGreeter = true;
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
