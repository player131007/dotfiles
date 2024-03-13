{
    imports = [
        ./eza
        ./starship
    ];

    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;

    programs.fish.enable = true;
    programs.hyprland.enable = true;
    programs.ssh.startAgent = true;
}
