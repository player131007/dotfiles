{
  config,
  npins,
  ...
}:
let
  theme = config.colorscheme {
    template = "${npins.tinted-btop}/templates/base16.mustache";
    extension = "theme";
  };
in
{
  xdg.configFile."btop/themes/${theme.name}" = {
    inherit (config.programs.btop) enable;
    source = theme;
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = theme.name-no-ext;
      truecolor = true;
      theme_background = false;
      update_ms = 1000;
      disks_filter = "/nix / /boot /d";
      swap_disk = false;
      proc_tree = true;
      proc_filter_kernel = true;
      proc_info_smaps = true;
    };
  };
}
