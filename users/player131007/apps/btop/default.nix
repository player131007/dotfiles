{ config, ... }: {
    xdg.configFile."btop/themes/base16.theme".source = config.scheme {
        template = ./btop.mustache;
        extension = ".theme";
    };

    programs.btop = {
        enable = true;
        settings = {
            color_theme = "${config.home.homeDirectory}/.config/btop/themes/base16.theme";
            truecolor = true;
            theme_background = false;
            update_ms = 1000;
            disks_filter = "/nix / /efi /d";
            swap_disk = false;
        };
    };
}
