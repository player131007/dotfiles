{
  flake.modules.maid.pc =
    { pkgs, lib, ... }:
    {
      packages = [ pkgs.qutebrowser ];
      systemd.tmpfiles.rules = [
        "f %h/.config/qutebrowser/colors.py - - - -"
      ];
      programs.wallust.settings.templates.qutebrowser = {
        template = ./colors.py;
        target = "~/.config/qutebrowser/colors.py";
      };
      programs.wallust.extraCommands = # bash
        ''
          pkill -HUP -u $USER -fx "^${lib.getExe pkgs.python3} ${lib.getExe' pkgs.qutebrowser ".qutebrowser-wrapped"}.*"
        '';
    };

  # TODO: fill up config
}
