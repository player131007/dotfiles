{ config, pkgs, ... }: {
    gtk =
    let
        finalCss = builtins.readFile (config.scheme {
            template = ./gtk.mustache;
            extension = ".css";
        });
    in
    {
        theme = {
            package = pkgs.adw-gtk3;
            name = "adw-gtk3";
        };
        gtk3.extraCss = finalCss;
        gtk4.extraCss = finalCss;
    };
}
