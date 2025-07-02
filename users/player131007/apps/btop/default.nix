{
  config,
  npins,
  ...
}:
{
  programs.btop = {
    enable = true;
    settings = {
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
