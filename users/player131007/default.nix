{ lib, pkgs, inputs, ... }:
with builtins;
{
    imports = [
        inputs.home-manager.nixosModule
    ];

    home-manager.users.player131007 = {
        imports = [
            inputs.base16.homeManagerModule
            ./apps.nix
        ];

        scheme = "${inputs.base16-schemes}/rose-pine.yaml";

        xdg.configFile = 
        let
             configFileNames =  attrNames (readDir ./.config);
        in lib.genAttrs configFileNames (name: { source = ./.config + "/${name}"; recursive = true; });

        gtk.enable = true;
        gtk.theme = {
            package = pkgs.rose-pine-gtk-theme;
            name = "rose-pine";
        };
        gtk.iconTheme = {
            package = pkgs.rose-pine-icon-theme;
            name = "rose-pine";
        };
        gtk.font = {
            package = pkgs.inter;
            name = "Inter";
            size = 11;
        };
        gtk.gtk4.extraCss = readFile "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk.css";

        home.pointerCursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 24;
        };

        home.stateVersion = "23.05";
    };
}
