{
  pkgs,
  lib,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = "${lib.getExe pkgs.tuigreet} -t -d -r --remember-user-session --asterisks --user-menu";
      general.source_profile = true;
    };
    useTextGreeter = true;
  };

  my.hjem = (
    { config, ... }:
    {
      # greetd will source ~/.profile when logging in
      files.".profile".text = # sh
        ''
          source ${config.environment.loadEnv}
        '';
    }
  );

  persist.at.oncedir.directories = lib.singleton {
    directory = "/var/cache/tuigreet";
    owner = "greeter";
    group = "greeter";
  };
}
