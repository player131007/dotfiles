{ modulesPath, pkgs, ... }:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment.systemPackages = [
    pkgs.neovim
    pkgs.e2fsprogs
  ];

  system.installer.channel.enable = false;
}
