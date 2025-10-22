{ modulesPath, pkgs, ... }:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment.systemPackages = [
    pkgs.cryptsetup
    pkgs.git
    pkgs.neovim
  ];
}
