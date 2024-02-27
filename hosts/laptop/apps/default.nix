{ pkgs, ... }:
{
    imports = [
        ./eza
        ./swaylock
        ./starship
    ];

    programs.command-not-found.enable = false;
    programs.nix-index.enable = true;

    programs.fish.enable = true;
    programs.hyprland.enable = true;
    programs.ssh.startAgent = true;
    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager
    ];
}
