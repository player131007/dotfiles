{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.modules.starship;
in
{
    options.modules.starship = {
        enable = mkEnableOption "starship";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [ pkgs.starship ];
        programs.bash.interactiveShellInit = ''
            export STARSHIP_CONFIG=${./starship.toml}
            if [[ "$TERM" != "linux" ]] && [[ "$TERM" != "dumb" ]]; then
                eval "$(starship init bash)"
            fi
        '';
        programs.fish.interactiveShellInit = ''
            export STARSHIP_CONFIG=${./starship.toml}
            if [ "$TERM" != "linux" ]; and [ "$TERM" != "dumb" ]
                starship init fish | source
            end
        '';
    };
}
