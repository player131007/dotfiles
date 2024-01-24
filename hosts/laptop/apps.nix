{ pkgs, inputs, ... }: {
    imports = with inputs; [
        (self + "/apps/nixos")
    ];

    programs.fish.enable = true;
    programs.hyprland.enable = true;
    programs.ssh.startAgent = true;
    environment.systemPackages = with pkgs; [
        gitMinimal
    ];
}
