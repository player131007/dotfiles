{ pkgs, lib, ... }: {
    imports = [
        ./btop
        ./firefox
        ./fish
        ./foot
        ./gtk
        ./fcitx5
        ./helix
    ];

    programs = {
        bash.enable = true;
        home-manager.enable = true;
    };

    programs.git = {
        enable = true;
        package = pkgs.git;
        userName = "Lương Việt Hoàng";
        userEmail = "tcm4095@gmail.com";
        extraConfig = {
            core.autocrlf = "input";
            core.pager = "less -FRX";
        };
    };

    home.packages = with pkgs; [
        dunst
        swaybg
        grim
        slurp
        brightnessctl
        mpv

        calc
        wl-clipboard
        foot
        ripgrep
        xdg-utils
        btop
        _7zz
        # broken as of now
        # wl-screenrec

        keepassxc
        looking-glass-client
        clang
    ];

    home.sessionVariables = {
        ASAN_SYMBOLIZER_PATH = lib.getExe' pkgs.llvm "llvm-symbolizer";
    };

}
