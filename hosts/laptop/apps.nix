{ pkgs, inputs, ... }:
{
    imports = [
        ../../apps/nixos
    ];

    programs.fish.enable = true;
    programs.hyprland.enable = true;
}
