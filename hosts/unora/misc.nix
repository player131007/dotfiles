{ lib, pkgs, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
    initrd.systemd.emergencyAccess = true;
    zswap.enable = true;
    kernel.sysctl."vm.swappiness" = 100;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  documentation = {
    dev.enable = false;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  nix.settings = {
    cores = 6;
    max-jobs = 6;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  swapDevices = lib.singleton {
    label = "swap";
  };
}
