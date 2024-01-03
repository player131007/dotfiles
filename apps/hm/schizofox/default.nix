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

        settings = {
            "content.notify.interval" = 100000;
            "layout.css.grid-template-masonry-value.enabled" = true;
            "dom.enable_web_task_scheduling" = true;
            "layout.css.has-selector.enabled" = true;
            "gfx.canvas.accelerated.cache-items" = 4096;
            "gfx.canvas.accelerated.cache-size" = 512;
            "gfx.content.skia-font-cache-size" = 20;
            "browser.cache.disk.enable" = false;
            "media.memory_cache_max_size" = 65536;
            "media.cache_readahead_limit" = 7200;
            "media.cache_resume_threshold" = 3600;
            "image.mem.decode_bytes_at_a_time" = 32768;
            "network.buffer.cache.size" = 262144;
            "network.buffer.cache.count" = 128;
            "network.http.max-connections" = 1800;
            "network.http.max-persistent-connections-per-server" = 10;
            "network.http.max-urgent-start-excessive-connections-per-host" = 5;
            "network.websocket.max-connections" = 400;
            "network.http.pacing.requests.enabled" = false;
            "network.dnsCacheEntries" = 10000;
            "network.dnsCacheExpiration" = 86400;
            "network.dns.max_high_priority_threads" = 8;
            "network.ssl_tokens_cache_capacity" = 20480;
            "network.early-hints.enabled" = true;
            "network.early-hints.preconnect.enabled" = true;
            "network.predictor.enabled" = false;
            "network.predictor.enable-prefetch" = false;
            "apz.overscroll.enabled" = true;
            "general.smoothScroll" = true;
            "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
            "general.smoothScroll.msdPhysics.enabled" = true;
            "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 600;
            "general.smoothScroll.msdPhysics.regularSpringConstant" = 650;
            "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 25;
            "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = 2.0;
            "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 250;
            "general.smoothScroll.currentVelocityWeighting" = 1.0;
            "general.smoothScroll.stopDecelerationWeighting" = 1.0;
            "mousewheel.default.delta_multiplier_y" = 300;
        };

        theme = {
            colors = {
                background-darker = config.scheme.base00;
                background = config.scheme.base01;
                foreground = config.scheme.base05;
                primary = config.scheme.base0D;
            };
            font = "Inter";
            extraUserChrome =
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
            searxUrl = "https://priv.au";
            defaultSearchEngine = "Searx";
            addEngines = [
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
        };

        extensions = {
            darkreader.enable = true;
            defaultExtensions = {
                "uBlock0@raymondhill.net".install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            };
        };
    };
}
