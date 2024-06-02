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
    };
    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager

        eza
        hyprlock
    ];

    security.pam.services.hyprlock = {};

    environment.shellAliases = {
        ls = "eza --icons -F";
        ll = "eza --icons -lhF";
        l = "eza --icons -lhaF";
    };
}
