{ config, ... }:
{
    programs.btop.enable = true;

    xdg.configFile."btop/themes/colors.theme".source = config.scheme {
        template = ./btop.mustache;
        extension = ".theme";
    };
    programs.btop.settings = {
        color_theme = "${config.home.homeDirectory}/.config/btop/themes/colors.theme";
        theme_background = false;
        truecolor = true;
        update_ms = 1000;
        disks_filter = "exclude=/persist /var/log /etc/NetworkManager/system-connections";
    };
}
