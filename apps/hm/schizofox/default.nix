{ inputs, pkgs, lib, config, ... }:
with builtins;
{
    imports = [
        inputs.schizofox.homeManagerModule
    ];

    fonts.fontconfig.enable = true;
    home.packages = [ pkgs.inter ];

    programs.schizofox = {
        enable = true;

        theme = {
            background = config.scheme.base00;
            foreground = config.scheme.base05;
            font = "Inter";
            darkreader.enable = true;
            extraCss =
            let
                cascade = pkgs.fetchFromGitHub {
                    owner = "player131007";
                    repo = "cascade";
                    rev = "3e6675b3dced7888f1439f4557197f398beef3c7";
                    hash = "sha256-FNac/LTxHb63UQgDqZBkHGtR2cRuNhmtKc5kpW592/o=";
                };
                files = filter (name: lib.hasSuffix ".css" name) (attrNames (readDir cascade));
            in
            (lib.concatStrings (map (name: "@import '${cascade}/${name}';\n") files))
            + "@import '${config.scheme {
                template = builtins.readFile "${cascade}/cascade-colours.mustache";
                extension = ".css";
            }}';";
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
}
