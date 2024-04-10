{ pkgs, ... }: {
    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;
    programs.starship = {
        enable = true;
        settings = fromTOML (builtins.readFile ./starship.toml);
    };
    programs.fish.enable = true;
    programs.hyprland.enable = true;
    programs.ssh.startAgent = true;

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
