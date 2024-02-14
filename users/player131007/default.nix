{ pkgs, inputs, ... }: {
    imports = [
        inputs.home-manager.nixosModule
    ];

    home-manager.users.player131007 = {
        imports = [
            inputs.base16.homeManagerModule
            ./apps
        ];

        scheme = "${inputs.base16-schemes}/base16/rose-pine.yaml";

        home.pointerCursor = {
            package = pkgs.bibata-cursors;
            name = "Bibata-Modern-Classic";
            size = 24;
        };

        home.stateVersion = "23.05";
    };
}
