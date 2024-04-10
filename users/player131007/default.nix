{ pkgs, ... }: {
    imports = [
        ./apps
    ];

    home.username = "player131007";
    home.homeDirectory = "/home/player131007";
    nix.package = pkgs.nix;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config = {
        allowUnfree = true;
        cudaSupport = true;
        packageOverrides = prev: {
            gitMinimal = prev.gitMinimal.override {
                withManual = true;
                doInstallCheck = false;
            };
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    scheme = ./rose-pine.yaml;

    home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
        gtk.enable = true;
    };

    home.stateVersion = "23.05";
}
