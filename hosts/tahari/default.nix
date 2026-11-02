{
  modulesPath,
  pkgs,
  wrappers',
  ...
}:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  nixpkgs.hostPlatform = "x86_64-linux";
  services.kmscon.config.font-engine = "unifont";

  environment.systemPackages = [
    (wrappers'.kakoune.modules.minimal { })
    pkgs.e2fsprogs
  ];

  security.run0.wheelNeedsPassword = false;

  system.installer.channel.enable = false;
}
