{ config, pkgs, lib, ... }: {
    programs.firefox = {
        enable = true;
        profiles.profile = {
            isDefault = true;
            userChrome =
            let
                baseXX = lib.filterAttrs (k: _: lib.hasPrefix "base" k && builtins.stringLength k == 6);
            in ''
                :root {
                    ${lib.concatLines (lib.mapAttrsToList (k: v: "--${k}: ${v};") (baseXX config.scheme.withHashtag))}
                }
                ${builtins.readFile ./userChrome.css}
            '';
        };

        package = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
            extraPrefs = lib.pipe [
                ./prefs/betterfox.js
                ./prefs/smooth_scrolling.js
            ] [
                (map builtins.readFile)
                lib.concatLines
            ];
            extraPolicies = {
                DisableAppUpdate = true;
                DisableFirefoxAccounts = true;
                DisableFirefoxStudies = true;
                DisablePocket = true;
                DisableTelemetry = true;
                DisplayBookmarksToolbar = "never";
                NoDefaultBookmarks = true;
                DisableSetDesktopBackground = true;

                OverrideFirstRunPage = "";
                DontCheckDefaultBrowser = true;
                PasswordManagerEnabled = false;
                OfferToSaveLogins = false;
                PromptForDownloadLocation = true;

                EnableTrackingProtection = {
                    Value = true;
                    Cryptomining = true;
                    Fingerprinting = true;
                    EmailTracking = true;
                };

                FirefoxHome = {
                    Search = true;
                    TopSites = true;
                    SponsoredTopSites = false;
                    Highlights = false;
                    Snippets = false;
                };

                SearchEngines = {
                    Remove = [
                        "Amazon.com"
                        "eBay"
                        "Bing"
                        "Wikipedia (en)"
                        "Google"
                    ];
                    Default = "DuckDuckGo";
                    Add = [
                        {
                            Name = "NixOS Packages (unstable)";
                            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
                            Alias = "!pkg";
                        }
                        {
                            Name = "NixOS Options (unstable)";
                            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
                            Alias = "!opt";
                        }
                        {
                            Name = "Home Manager options";
                            URLTemplate = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
                            Alias = "!hm";
                        }
                    ];
                };

                ManagedBookmarks = [
                    {
                        url = "https://nixos.org/manual/nixpkgs/unstable/";
                        name = "Nixpkgs manual";
                    }
                    {
                        url = "https://nix.dev/manual/nix/rolling/language/builtins";
                        name = "Nix built-in functions";
                    }
                ];

                ExtensionSettings = {
                    "keepassxc-browser@keepassxc.org" = {
                        installation_mode = "normal_installed";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi";
                    };
                    "uBlock0@raymondhill.net" = {
                        installation_mode = "normal_installed";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                    };
                    "addon@darkreader.org" =
                    let
                        darkreader = pkgs.callPackage ./darkreader.nix (with config.scheme; {
                            background = base01;
                            text = base05;
                            isDarkTheme = variant != "light";
                        });
                    in {
                        installation_mode = "normal_installed";
                        install_url = "file://${darkreader}/release/darkreader-firefox.xpi";
                    };
                };
            };
        };
    };
}
