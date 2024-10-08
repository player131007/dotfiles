{ pkgs, ... }: {
    imports = [
        ./btop
        ./firefox
        ./fish
        ./foot
        ./gtk
        ./hyprland
        ./fcitx5
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
        looking-glass-client
    ];

    systemd.user.services = {
        keepassxc = {
            Unit = {
                Description = "KeepassXC";
                Documentation = [ "man:keepassxc(1)" ];
                After = [ "ssh-agent.service" ];
            };
            Install = {
                WantedBy = [ "graphical-session.target" ];
            };
            Service = {
                Type = "exec";
                ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
                Environment = [ "QT_QPA_PLATFORM=wayland;xcb" "SSH_AUTH_SOCK=%t/ssh-agent" ];
            };
        };
    };
}

