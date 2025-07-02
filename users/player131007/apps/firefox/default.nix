{
  pkgs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    profiles.profile = {
      isDefault = true;
    };

    package = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
      # https://github.com/NixOS/nixpkgs/pull/397970 funny
      extraPrefsFiles = [
        "${./prefs/betterfox.js}"
        "${./prefs/smooth_scrolling.js}"
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

        Bookmarks = [
          {
            Title = "Nixpkgs manual";
            URL = "https://nixos.org/manual/nixpkgs/unstable";
            Favicon = "https://nix.dev/_static/favicon.png";
            Placement = "menu";
            Folder = "nix stuff";
          }
          {
            Title = "Nix manual";
            URL = "https://nix.dev/manual/nix/rolling";
            Favicon = "https://nix.dev/_static/favicon.png";
            Placement = "menu";
            Folder = "nix stuff";
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
        };
      };
    };
  };
}
