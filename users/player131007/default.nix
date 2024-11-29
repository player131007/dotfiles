{ pkgs, ... }: {
    imports = [
        ./apps
    ];

    xdg.configFile."startup".source = pkgs.writeShellScript "startup" ''
        swaybg -i ${./wallpaper.png} &
        keepassxc &

        wait -f
    '';

    home.username = "player131007";
    home.homeDirectory = "/home/player131007";

    scheme = ../../rose-pine.yaml;

    home.pointerCursor = {
        package = pkgs.bibata-cursors.overrideAttrs {
            buildPhase = ''
                runHook preBuild
                ctgen configs/normal/x.build.toml -p x11 -d $bitmaps/Bibata-Modern-Classic -n 'Bibata-Modern-Classic' -c 'Black and rounded edge Bibata cursors.'
                runHook postBuild
            '';
        };
        name = "Bibata-Modern-Classic";
        size = 24;
        gtk.enable = true;
    };

    home.stateVersion = "23.05";
}
