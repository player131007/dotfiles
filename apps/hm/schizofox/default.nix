{ inputs, pkgs, lib, ... }:
with builtins;
{
    imports = [
        inputs.schizofox.homeManagerModule
    ];

    home.packages = [
        pkgs.inter
    ];
    fonts.fontconfig.enable = true;

    programs.schizofox = {
        enable = true;

        theme = {
            background-darker = "191724";
            background = "1f142e";
            foreground = "e0def4";
            font = "Inter";
            darkreader.enable = true;
            extraCss =
            let
                cascade = pkgs.fetchFromGitHub {
                    owner = "player131007";
                    repo = "cascade";
                    rev = "8d0b8b08782c1933f08ae19e11c94472b03a96f7";
                    hash = "sha256-Kvu9IwtalpWuo0ekhi/Wl/01NxHZlfPYK6BLj0e4ZUQ=";
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
}
