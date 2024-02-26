{ pkgs, inputs, ... }: {
    imports = [
        inputs.base16.homeManagerModule
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
            gitMinimal = prev.gitMinimal.override { withManual = true; };
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    scheme = "${inputs.base16-schemes}/base16/rose-pine.yaml";

    home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
    };

    home.stateVersion = "23.05";
}
