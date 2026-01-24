{ modulesPath, pkgs, ... }:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment.systemPackages = [
    pkgs.git
    pkgs.neovim
    pkgs.e2fsprogs
  ];
}
