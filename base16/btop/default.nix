{ config, ... }: {
    xdg.configFile."btop/themes/base16.theme".source = config.scheme {
        template = ./btop.mustache;
        extension = ".theme";
    };
    programs.btop.settings = {
        color_theme = "${config.home.homeDirectory}/.config/btop/themes/base16.theme";
        truecolor = true;
    };
}
