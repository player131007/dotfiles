{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.qutebrowser ];
      systemd.tmpfiles.rules = [
        "f %h/.config/qutebrowser/colors.py - - - -"
      ];
      programs.wallust.settings.templates.qutebrowser = {
        template = ./colors.py;
        target = "~/.config/qutebrowser/colors.py";
      };
    };

  # TODO: fill up config
}
