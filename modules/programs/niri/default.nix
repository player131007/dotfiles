# why this instead of wrappers?
# i often temporarily edit the niri config, and it also live reloads too

{ pkgs, ... }:
{
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  services.gnome.gnome-keyring.enable = false;
  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.wl-clipboard
  ];
}
