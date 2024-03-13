{ pkgs, ... }: {
    environment.systemPackages = [ pkgs.hyprlock ];
    security.pam.services.hyprlock = {};
}
