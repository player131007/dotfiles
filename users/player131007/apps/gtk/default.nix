{ pkgs, config, ... }:
let
    isDarkTheme = config.scheme.variant != "light";
in {
    gtk =
    let
        base16Css = builtins.readFile (config.scheme {
            template = ./gtk.mustache;
            extension = ".css";
        });
    in {
        enable = true;
        font = {
            package = pkgs.inter;
            name = "Inter";
        };

        iconTheme = {
            package = pkgs.gnome.adwaita-icon-theme;
            name = "Adwaita";
        };

        theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3";
        };
        gtk3.extraCss = base16Css;
        gtk4.extraCss = base16Css;

        gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = isDarkTheme;
        };
        gtk4.extraConfig = {
            gtk-application-prefer-dark-theme = isDarkTheme;
        };
    };

    dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = if isDarkTheme then "prefer-dark" else "prefer-light";
    };
}
