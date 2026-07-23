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

  my.tmpfiles = [
    "r %h/.config/gtk-4.0/gtk.css - - - - -"
    "C %h/.config/gtk-4.0/gtk.css 0600 - - - ${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk.css"
  ];

  qt.enable = true;
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
