{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.modules.eza;
in
{
    options.modules.eza = {
        enable = mkEnableOption "eza";
        lsAliases = mkOption {
            type = types.bool;
            default = true;
            example = false;
            description = "Whether to add ls aliases for eza";
        };
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [ pkgs.eza ];
        programs.bash.interactiveShellInit = optionalString cfg.lsAliases ''
            if [[ "$TERM" == "linux" ]]; then
                eza_use_icons=never
            else
                eza_use_icons=auto
            fi
        '';
        programs.fish.interactiveShellInit = optionalString cfg.lsAliases ''
            if [ "$TERM" = "linux" ]
                set eza_use_icons never
            else
                set eza_use_icons auto
            end
        '';
        
        environment.shellAliases = {
            l = "eza --icons=$eza_use_icons -Flha";
            ls = "eza --icons=$eza_use_icons -F";
            ll = "eza --icons=$eza_use_icons -Flh";
        };
    };
}
