{
  flake.modules.nixos.pc =
    { lib, pkgs, ... }:
    {
      services.greetd = {
        enable = true;
        vt = 2;
        settings.default_session.command = "${lib.getExe pkgs.greetd.tuigreet} -t -d -r --remember-user-session --asterisks --user-menu";
      };
    };
}
