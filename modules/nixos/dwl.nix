{ pkgs, config, lib, modulesPath, ... }:
let
    cfg = config.stuffs.dwl;
in {
    options.stuffs.dwl = {
        enable = lib.mkEnableOption "dwl";
        package = lib.mkPackageOption pkgs "dwl" {};
        wrapperArgs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            internal = true;
            description = "Arguments passed to `makeWrapper`.";
        };

        finalPackage = lib.mkOption {
            type = lib.types.package;
            readOnly = true;
        };

        envVariables = lib.mkOption {
            type = lib.types.attrsOf (lib.types.uniq lib.types.str);
            default = {};
            description = "Environment variables to pass to dwl.";
        };

        startupCommand = lib.mkOption {
            type = lib.types.uniq lib.types.str;
            default = "";
            description = ''
                Command to run after dwl starts.
                Note that this will be ran as a child process and thus can't change the environment of dwl.
            '';
        };
    };

    config = lib.mkIf cfg.enable (lib.mkMerge
    [
        {
            stuffs.dwl.wrapperArgs = lib.optionals (cfg.startupCommand != "") [
                "--append-flags" "-s"
                "--append-flags" cfg.startupCommand
            ] ++ lib.foldlAttrs (acc: name: value: acc ++ [ "--set" name value ]) [] cfg.envVariables;

            stuffs.dwl.finalPackage = cfg.package.overrideAttrs (prev: {
                nativeBuildInputs = prev.nativeBuildInputs or [] ++ lib.optional (cfg.wrapperArgs != []) pkgs.makeWrapper;
                postInstall = prev.postInstall or "" + lib.optionalString (cfg.wrapperArgs != []) ''
                    wrapProgram $out/bin/dwl ${lib.escapeShellArgs cfg.wrapperArgs}
                '';
            });

            environment.systemPackages = [ cfg.finalPackage ];
            services.displayManager.sessionPackages = [ cfg.finalPackage ];

            xdg.portal.config.dwl = {
                default = [ "wlr" "gtk" ];
            };
        }
        (import "${modulesPath}/programs/wayland/wayland-session.nix" { inherit lib pkgs; })
    ]);
}
