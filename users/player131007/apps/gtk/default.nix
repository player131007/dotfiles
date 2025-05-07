{
  pkgs,
  config,
  ...
}:
let
  isDarkTheme = config.scheme.variant != "light";

  gtkConfig = {
    extraCss = builtins.readFile (
      config.scheme {
        template = ./gtk.mustache;
        extension = ".css";
      }
    );
    extraConfig = {
      gtk-application-prefer-dark-theme = isDarkTheme;
    };
  };
in
{
  gtk = {
    enable = true;
    font = {
      package = pkgs.inter;
      name = "Inter";
    };

    iconTheme = {
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
    };

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };

    gtk3 = gtkConfig;
    gtk4 = gtkConfig;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = if isDarkTheme then "prefer-dark" else "prefer-light";
  };
}
