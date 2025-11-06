{ pkgs, ... }:
{
  programs.niri.enable = true;
  environment.systemPackages = [ pkgs.xwayland-satellite ];
  services.gnome.gnome-keyring.enable = false;
  xdg.portal.config.niri = {
    # from niri-portals.conf
    default = [
      "gnome"
      "gtk"
    ];
    "org.freedesktop.impl.portal.Access" = "gtk";
    "org.freedesktop.impl.portal.Notification" = "gtk";

    # custom
    "org.freedesktop.impl.portal.FileChooser" = "gtk";
  };

  xdg.icons.enable = true;
  my.hjem = (
    { config, ... }:
    {
      packages = [ pkgs.bibata-cursors ];
      xdg.config.files."niri/config.kdl".source =
        "${config.directory}/dots/modules/programs/extras/niri/config.kdl";
    }
  );
}
