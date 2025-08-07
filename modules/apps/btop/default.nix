{
  flake.modules.maid.pc = {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "wallust";
        truecolor = true;
        theme_background = false;
        update_ms = 1000;
        swap_disk = false;
        proc_tree = true;
        proc_filter_kernel = true;
        proc_info_smaps = true;
      };
    };

    programs.wallust.settings.templates.btop = {
      template = ./btop.theme;
      target = "~/.config/btop/themes/wallust.theme";
    };
    programs.wallust.extraCommands = # bash
      ''
        pkill -USR2 -u $USER btop
      '';
  };
}
