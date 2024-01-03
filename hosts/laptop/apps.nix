{
    imports = [
        ../../apps/nixos
    ];

    programs.fish.enable = true;
    programs.hyprland.enable = true;
    programs.ssh.startAgent = true;
}
