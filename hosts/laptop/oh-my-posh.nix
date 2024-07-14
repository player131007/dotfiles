{ config, lib, pkgs, ... }:
let
    cfg = config.stuffs.oh-my-posh;
in {
    options.stuffs.oh-my-posh = {
        enable = lib.mkEnableOption "oh-my-posh";
        package = lib.mkPackageOption pkgs "oh-my-posh" {};
        configFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "path to config file for oh-my-posh";
        };

        enableBashIntegration = lib.mkEnableOption "bash integration for oh-my-posh" // { default = true; };
        enableFishIntegration = lib.mkEnableOption "fish integration for oh-my-posh" // { default = true; };
        enableZshIntegration = lib.mkEnableOption "zsh integration for oh-my-posh" // { default = true; };
    };

    config =
    let
        configArgument = lib.optionalString (cfg.configFile != null) "--config ${cfg.configFile}";
    in lib.mkIf cfg.enable {
        programs.bash.promptInit = lib.mkIf cfg.enableBashIntegration ''
            eval "$(${cfg.package}/bin/oh-my-posh init bash ${configArgument})"
        '';

        programs.fish.promptInit = lib.mkIf cfg.enableFishIntegration ''
            ${cfg.package}/bin/oh-my-posh init fish ${configArgument} | source
        '';

        programs.zsh.promptInit = lib.mkIf cfg.enableZshIntegration ''
            eval "$(${cfg.package}/bin/oh-my-posh init zsh ${configArgument})"
        '';
    };
}
