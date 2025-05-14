{
  pkgs,
  config,
  ...
}:
let
  darkMode = config.colorscheme.variant == "dark";

  gtkConfig = {
    extraCss =
      let
        theme = config.colorscheme {
          template = ./gtk.css.mustache;
          extension = "css";
        };
      in
      ''
        @import "${theme}";
      '';
    extraConfig.gtk-application-prefer-dark-theme = darkMode;
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
    color-scheme = if darkMode then "prefer-dark" else "prefer-light";
  };
}
