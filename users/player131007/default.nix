inputs: { lib, pkgs, ... }:
with builtins;
let
    configFileNames =  attrNames (readDir ./.config);
in
{
    _module.args.inputs = inputs;
    imports = [
        inputs.schizofox.homeManagerModule
        ../../modules/hm
    ];

    xdg.configFile = lib.genAttrs configFileNames (name: { source = ./.config + "/${name}"; });

    gtk.enable = true;
    gtk.theme = {
        package = pkgs.rose-pine-gtk-theme;
        name = "rose-pine";
    };
    gtk.iconTheme = {
        package = pkgs.rose-pine-icon-theme;
        name = "rose-pine";
    };
    gtk.gtk4.extraCss = readFile "${pkgs.rose-pine-gtk-theme}/share/themes/rose-pine/gtk-4.0/gtk.css";

    home.pointerCursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
    };

    home.packages = [
        pkgs.inter
    ];
    fonts.fontconfig.enable = true;

    gtk.font = {
        name = "Inter";
        size = 11;
    };

    programs.schizofox = {
        enable = true;

        theme = {
            background-darker = "191724";
            background = "1f142e";
            foreground = "e0def4";
            font = "Inter";
            darkreader.enable = true;
            simplefox.enable = false;
            extraCss =
            let
                cascade = pkgs.fetchFromGitHub {
                    owner = "player131007";
                    repo = "cascade";
                    rev = "9ce31d0e7cbd140f341c796df930b6b5578e73ba";
                    hash = "sha256-KBfd5/BsizAsJyesP39/OJoZjBPdTEnTMjljHU2wwo0=";
                };
                files = filter (name: lib.hasSuffix ".css" name) (attrNames (readDir cascade));
            in lib.concatStrings (map (name: "@import '${cascade}/${name}';\n") files);
        };

        search = {
            addEngines = [
                {
                    Name = "Searx";
                    URLTemplate = "https://priv.au/search?q={searchTerms}";
                }
                {
                    Name = "NixOS Packages";
                    URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
                    Alias = "!pkg";
                }
                {
                    Name = "NixOS Options";
                    URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
                    Alias = "!opt";
                }
            ];
            defaultSearchEngine = "Searx";
        };

        extensions.defaultExtensions = {
            "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
    };

    home.stateVersion = "23.05";
}
