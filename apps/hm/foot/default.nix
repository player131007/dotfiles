{ pkgs, config, inputs, ... }: {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];

    programs.foot.enable = true;
    programs.foot.settings = {
        main = {
            include = config.scheme inputs.base16-foot;
            font = "MesloLGS Nerd Font Mono:size=11";
            shell = "fish";
            pad = "5x5 center";
        };
        cursor = {
            blink = "yes";
        };
        colors = {
            alpha = 0.6;
        };
    };

    programs.fish.interactiveShellInit = ''
        function mark_prompt_start --on-event fish_prompt
            echo -en "\e]133;A\e\\"
        end
    '';

    programs.bash.initExtra = ''
        prompt_marker() {
            printf '\e]133;A\e\\'
        }
        PROMPT_COMMAND=''${PROMPT_COMMAND:+$PROMPT_COMMAND; }prompt_marker
    '';
}
