{ pkgs, inputs, ... }:
{
    imports = [
        ../../apps/hm
        inputs.ags.homeManagerModules.default
    ];

    programs = {
        neovim = {
            enable = true;
            defaultEditor = true;
        };
        ags.enable = true;
        bash.enable = true;
    };

    programs.fish.interactiveShellInit = ''
        fish_config theme choose "Rosé Pine"
        function mark_prompt_start --on-event fish_prompt
            echo -en "\e]133;A\e\\"
        end
    '';

    programs.git = {
        enable = true;
        package = pkgs.gitMinimal;
        userName = "Lương Việt Hoàng";
        userEmail = "tcm4095@gmail.com";
        extraConfig = {
            core.autocrlf = "input";
            credential.helper = "store";
        };
    };

    home.packages = with pkgs; [
        clang_16
        llvmPackages_16.libllvm

        nil
        clang-tools_16 # clangd

        dunst
        swaybg
        grim
        slurp
        brightnessctl

        wl-clipboard
        foot
        ripgrep
        xdg-utils
        btop
        _7zz
        wl-screenrec
    ];
}
