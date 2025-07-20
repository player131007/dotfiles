{
  flake.modules.nixos.pc = {
    programs.niri.enable = true;
    services.gnome.gnome-keyring.enable = false;
    xdg.portal.config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      # no secrets portal
    };
  };

  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.bibata-cursors ];
      file.xdg_config."niri/config.kdl".source = ./config.kdl;
    };
}
