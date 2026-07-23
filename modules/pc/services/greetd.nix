{
  lib,
  pkgs,
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

  persist.at.oncedir.directories = lib.singleton {
    directory = "/var/cache/tuigreet";
    owner = "greeter";
    group = "greeter";
  };
}
