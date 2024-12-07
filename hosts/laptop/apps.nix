{ pkgs, lib, config, ... }: {
    programs = {
        command-not-found.enable = false;
        nix-index.enable = true;
        fish.enable = true;
        ssh.startAgent = true;

        virt-manager.enable = true;
        nano.enable = false;
    };

    environment.variables = lib.optionalAttrs config.documentation.man.enable {
        MANROFFOPT = "-P-c"; # less doesn't support coloring ANSI escape codes
        MANPAGER = "less -Dd+y -Du+b";
    } // lib.optionalAttrs config.programs.less.enable {
        LESS = "-R --use-color";
    };

    stuffs.oh-my-posh = {
        enable = true;
        configFile = ./pure.omp.toml;
    };

    stuffs.dwl = {
        enable = true;
        package = with config.scheme; pkgs.callPackage ./dwl.nix {
            rootColor = "0x${base00}ff";
            borderColor = "0x${base02}ff";
            focusColor = "0x${base14}ff";
            urgentColor = "0x${base12}ff";
        };
        envVariables = {
            MOZ_ENABLE_WAYLAND = "1";
            GDK_BACKEND = "wayland,x11";
            QT_QPA_PLATFORM = "wayland;xcb";
        };

        startupCommand = "$HOME/.config/startup";
    };

    environment.systemPackages = with pkgs; [
        git
        home-manager

        eza
        virtiofsd

        man-pages
    ];

    environment.shellAliases = {
        ls = "eza --icons -F";
        ll = "eza --icons -F -lhb";
        l = "eza --icons -F -lhba";
    };
}
