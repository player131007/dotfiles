{ config, pkgs, ... }:
{
    gtk =
    let
        finalCss = builtins.readFile (config.scheme {
            template = ./gtk.mustache;
            extension = ".css";
        });
    in
    {
        enable = true;
        theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3";
        };
        font = {
            package = pkgs.inter;
            name = "Inter";
        };
        gtk3.extraCss = finalCss;
        gtk4.extraCss = finalCss;

        gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = true;
        };
        gtk4.extraConfig = {
            gtk-application-prefer-dark-theme = true;
        };
    };

    dconf.settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
    };
}
