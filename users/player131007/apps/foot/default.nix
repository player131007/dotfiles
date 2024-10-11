{ pkgs, config, ... }: {
    home.packages = [
        (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; })
    ];

    programs.foot = {
        enable = true;
        settings = {
            main = {
                include = config.scheme {
                    template = ./foot.mustache;
                    extension = ".ini";
                };
                font = "MesloLGS Nerd Font Mono:size=11";
                shell = "fish";
                pad = "5x5 center";
            };
            cursor.blink = "yes";
            colors.alpha = 0.7;
        };
    };

    # oh-my-posh will take care of shell integration
}
