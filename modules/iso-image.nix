{ modulesPath, pkgs, ... }:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment.systemPackages = [
    pkgs.kakoune-unwrapped
    pkgs.e2fsprogs
  ];

  security.run0.wheelNeedsPassword = false;

  system.installer.channel.enable = false;
}
