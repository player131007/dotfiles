{ pkgs, ... }: {
    programs = {
        command-not-found.enable = false;
        nix-index.enable = true;
        starship = {
            enable = true;
            settings = fromTOML (builtins.readFile ./starship.toml);
        };
        fish.enable = true;
        ssh.startAgent = true;

        hyprland.enable = true;
        hyprlock.enable = true;
        virt-manager.enable = true;
    };

    environment.systemPackages = with pkgs; [
        gitMinimal
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
