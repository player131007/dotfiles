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

        home.pointerCursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 24;
        };

        home.stateVersion = "23.05";
    };
}
