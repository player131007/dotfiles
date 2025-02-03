{ pkgs, config, ... }: {
    home.packages = [
        pkgs.nerd-fonts.symbols-only
        pkgs.inter
    ];

    programs.yambar.enable = true;

    xdg.configFile."yambar/config.yml" = {
        inherit (config.programs.yambar) enable;
        source = config.scheme {
            template = ./config.mustache;
            extension = ".yml";
        };
    };
}
