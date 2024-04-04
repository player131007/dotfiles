{ config, pkgs, lib, ... }: {
    programs.firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
            nativeMessagingHosts = [ pkgs.keepassxc ];
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

                ExtensionSettings = {
                    "uBlock0@raymondhill.net" = {
                        installation_mode = "normal_installed";
                        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                    };
                    "addon@darkreader.org" =
                    let
                        darkreader = with config.scheme; pkgs.callPackage ./darkreader.nix {
                            background = base01;
                            text = base05;
                            isDarkTheme = variant != "light";
                        };
                    in
                    {
                        installation_mode = "normal_installed";
                        install_url = "file://${darkreader}/release/darkreader-firefox.xpi";
                    };
                };
            };
        };
    };
}
