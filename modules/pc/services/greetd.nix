{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = lib.getExe pkgs.tuigreet;
      general.source_profile = true;
    };
    useTextGreeter = true;
  };

  environment.etc."tuigreet/config.toml".source =
    let
      format = pkgs.formats.toml { };
    in
    format.generate "tuigreet-config.toml" {
      general.debug = true;
      display.show_time = true;
      remember = {
        username = true;
        user_session = true;
      };

      secret = {
        mode = "characters";
        characters = "*";
      };
    };

  persist.at.oncedir.directories = lib.singleton {
    directory = "/var/cache/tuigreet";
    owner = "greeter";
    group = "greeter";
  };
}
