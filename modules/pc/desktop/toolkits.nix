{ lib, pkgs, ... }:
{
  # GTK
  environment.systemPackages = [ pkgs.adw-gtk3 ];
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

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };
}
