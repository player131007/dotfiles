{ pkgs, ... }: {
    imports = [
        ./apps
    ];

    home.username = "player131007";
    home.homeDirectory = "/home/player131007";

    scheme = ../../rose-pine.yaml;

    home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
        gtk.enable = true;
    };

    home.stateVersion = "23.05";
}
