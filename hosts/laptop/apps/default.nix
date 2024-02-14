{ pkgs, ... }:
{
    imports = [
        ./eza
        ./swaylock
        ./starship
    ];

    programs.fish.enable = true;
    programs.hyprland.enable = true;
    programs.ssh.startAgent = true;
    environment.systemPackages = with pkgs; [
        gitMinimal
    ];
}
