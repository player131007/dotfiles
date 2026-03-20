{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  services.gnome.gnome-keyring.enable = false;
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  my.hjem = {
    xdg.config.files."niri/config.kdl" = {
      enable = true;
      text = builtins.readFile ./config.kdl;
      type = "copy";
      permissions = "600";
    };
  };
}
