{ pkgs, lib, config, ... }: {
    home.packages = [
        pkgs.nerd-fonts.symbols-only
        pkgs.inter
    ];

    programs.yambar = {
        enable = true;
        # until new release
        package =
        let
            rev = "b15714b38a1ed58196046d4365c45e85f552a8ce";
        in (pkgs.yambar.override { x11Support = false; }).overrideAttrs (prev: {
            version = "1.12.0-dev-${builtins.substring 0 8 rev}";

            src = pkgs.fetchFromGitea {
                domain = "codeberg.org";
                owner = "dnkl";
                repo = "yambar";
                inherit rev;
                hash = "sha256-cJsGNf2/7+n5us+XEA9TC01h4Yj2oIDxmHEldMQ//aY=";
            };

            mesonFlags = prev.mesonFlags or [] ++ [
                (lib.mesonEnable "plugin-xkb" false)
            ];
        });
    };

    xdg.configFile."yambar/config.yml" = {
        inherit (config.programs.yambar) enable;
        source = config.scheme {
            template = ./config.mustache;
            extension = ".yml";
        };
    };
}
