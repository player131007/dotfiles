{ pkgs, nvim-flake, config, ... }: {
    imports = [
        ./oh-my-posh.nix
    ];

    programs = {
        command-not-found.enable = false;
        nix-index.enable = true;
        fish.enable = true;
        ssh.startAgent = true;

        hyprland.enable = true;
        hyprlock.enable = true;
        virt-manager.enable = true;
    };

    stuffs.oh-my-posh = {
        enable = true;
        configFile = ./pure.omp.toml;
    };

    environment.variables.EDITOR = "nvim";
    environment.systemPackages = with pkgs; [
        git
        home-manager

        eza
        virtiofsd
        (nvim-flake.packages.${pkgs.system}.default.override {
            colorscheme =
            let
                baseXX = lib.filterAttrs (k: _: lib.hasPrefix "base" k && builtins.stringLength k == 6);
            in baseXX config.scheme.withHashtag;
        })
    ];

    environment.shellAliases = {
        ls = "eza --icons -F";
        ll = "eza --icons -F -lhb";
        l = "eza --icons -F -lhba";
    };

    programs.fish.interactiveShellInit = ''
        function man2 -w man
            nvim +"Man $argv | only"
        end
    '';
    programs.bash.interactiveShellInit = ''
        man2() {
            nvim +"Man $@ | only"
        }
    '';
}
