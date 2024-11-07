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
