{ pkgs, ... }: {
    imports = [
        ./btop
        ./firefox
        ./fish
        ./foot
        ./gtk
        ./nvim
        ./hyprland
        ./fcitx5
    ];

    programs = {
        bash.enable = true;
        home-manager.enable = true;
    };

    programs.git = {
        enable = true;
        package = pkgs.gitMinimal;
        userName = "Lương Việt Hoàng";
        userEmail = "tcm4095@gmail.com";
        extraConfig = {
            core.autocrlf = "input";
        };
    };

    home.packages = with pkgs; [
        dunst
        swaybg
        grim
        slurp
        brightnessctl

        calc
        wl-clipboard
        foot
        ripgrep
        xdg-utils
        btop
        _7zz
        wl-screenrec

        keepassxc
    ];
}

