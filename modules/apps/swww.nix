{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      programs.swww.enable = true;
      programs.wallust.settings.templates.wallpaper = {
        template = pkgs.writeText "wallpaper-template" "{{ wallpaper }}";
        target = "~/.cache/wallpaper";
      };
      programs.wallust.extraCommands = # bash
        ''
          swww img --transition-type random --transition-fps 120 --transition-duration 1 -- "$(<~/.cache/wallpaper)"
          rm ~/.cache/wallpaper
        '';
    };
}
