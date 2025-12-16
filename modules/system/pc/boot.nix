{ pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    tmp.cleanOnBoot = true;

    initrd.systemd.emergencyAccess = true;

    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot = {
      enable = true;
      editor = false;
    };
  };
}
