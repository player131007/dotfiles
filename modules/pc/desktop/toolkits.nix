{ lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.adw-gtk3

    pkgs.libsForQt5.qt5ct
    pkgs.qt6Packages.qt6ct
  ];

  programs.dconf = {
    enable = true;
    profiles.user.databases = lib.singleton {
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = "adw-gtk3";
        };
      };
    };
  };

  qt.enable = true;
  environment.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
}
