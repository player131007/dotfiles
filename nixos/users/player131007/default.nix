{ lib, pkgs, ... }:
with builtins;
let
    fileNames = filter (name: name != ".config") (attrNames (readDir ./home));
    configFileNames =  attrNames (readDir ./home/.config);
in
{
    programs.home-manager.enable = true;
    home.file = lib.genAttrs fileNames (name: { source = ./home + "/${name}"; });
    xdg.configFile = lib.genAttrs configFileNames (name: { source = ./home/.config + "/${name}"; });

    gtk.enable = true;
    gtk.theme = {
        package = pkgs.rose-pine-gtk-theme;
        name = "rose-pine";
    };
    gtk.iconTheme = {
        package = pkgs.rose-pine-icon-theme;
        name = "rose-pine";
    };
    gtk.gtk4.extraCss = readFile "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk.css";

    home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
    };

    home.stateVersion = "23.05";
}
