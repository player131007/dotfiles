{ pkgs, config, lib, ... }: {
    xdg.configFile."helix/themes/base16.toml".source = config.scheme {
        template = ./helix.mustache;
        extension = ".toml";
    };

    programs.helix = {
        enable = true;
        defaultEditor = true;
        settings = {
            theme = "base16";
            editor = {
                line-number = "relative";
                mouse = false;
                middle-click-paste = false;
                popup-border = "popup";
                color-modes = true;
            };
            editor.cursor-shape.insert = "bar";
            editor.indent-guides = {
                render = true;
                character = "▏";
                skip = 1;
            };
        };

        languages = {
            language-server.clangd = {
                command = lib.getExe' pkgs.clang-tools "clangd";
                args = [
                    "--header-insertion=never"
                    "--header-insertion-decorators=false"
                    "-j"
                    "8"
                    "--malloc-trim"
                    "--pch-storage=memory"
                ];
            };

            language-server.nixd = {
                command = lib.getExe pkgs.nixd;
            };

            language = [
                {
                    name = "nix";
                    language-servers = [ "nixd" ];
                    indent = { tab-width = 4; unit = "    "; };
                }
                {
                    name = "cpp";
                    indent = { tab-width = 4; unit = "    "; };
                }
            ];
        };
    };
}
