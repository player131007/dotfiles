{ modulesPath, pkgs, ... }:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  environment.systemPackages = [
    pkgs.neovim
    pkgs.e2fsprogs
  ];

  security.polkit.extraConfig = /* javascript */ ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  system.installer.channel.enable = false;
}
