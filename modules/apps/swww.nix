{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      programs.swww.enable = true;
      programs.wallust.settings.templates.swww = {
        template = pkgs.writeShellScript "set-wallpaper" ''
          exec swww img --transition-type random --transition-fps 120 --transition-duration 1 -- "{{ wallpaper }}"
        '';
        target = "~/.cache/set-wallpaper.sh";
      };
      programs.wallust.extraCommands = # bash
        ''
          bash ~/.cache/set-wallpaper.sh
        '';
    };
}
