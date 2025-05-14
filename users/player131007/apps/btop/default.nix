{
  config,
  npins,
  ...
}:
{
  xdg.configFile."btop/themes/${config.colorscheme.system}-${config.colorscheme.slug}.theme" = {
    inherit (config.programs.btop) enable;
    source = config.colorscheme {
      template = "${npins.tinted-btop}/templates/base16.mustache";
      extension = "theme";
    };
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "${config.colorscheme.system}-${config.colorscheme.slug}";
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
