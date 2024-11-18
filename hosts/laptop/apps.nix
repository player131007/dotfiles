{ pkgs, lib, config, ... }: {
    imports = [
        ./oh-my-posh.nix
    ];

    programs = {
        command-not-found.enable = false;
        nix-index.enable = true;
        fish.enable = true;
        ssh.startAgent = true;

        hyprland.enable = true;
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

    environment.systemPackages = with pkgs; [
        git
        home-manager

        eza
        virtiofsd
    ];

    environment.shellAliases = {
        ls = "eza --icons -F";
        ll = "eza --icons -F -lhb";
        l = "eza --icons -F -lhba";
    };
}
