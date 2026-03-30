{ lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.rose-pine-gtk-theme

    pkgs.libsForQt5.qt5ct
    pkgs.libsForQt5.qtstyleplugin-kvantum

    pkgs.qt6Packages.qt6ct
    pkgs.qt6Packages.qtstyleplugin-kvantum
  ];

  programs.dconf = {
    enable = true;
    profiles.user.databases = lib.singleton {
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = "rose-pine";
        };
      };
    };
  };

  my.hjem = {
    xdg.config.files."gtk-4.0/gtk.css" = {
      type = "copy";
      permissions = "600";
      text = /* css */ ''
        @import url("${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk.css");
      '';
    };
  };

  qt.enable = true;
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
