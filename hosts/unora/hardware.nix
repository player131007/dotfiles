{
  config,
  lib,
  myLib,
  ...
}:
{
  imports = [ (myLib.fromRoot "modules/nvidia.nix") ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.blacklistedKernelModules = [ "k10temp" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.zenpower ];
  boot.kernelModules = [ "zenpower" ];
  boot.kernelParams = [ "amd_pstate=active" ];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
    "sdhci_pci"
    "hid_generic"
  ];

  hardware = {
    enableRedistributableFirmware = true;

    cpu.amd.updateMicrocode = true;
    amdgpu.initrd.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    graphics.enable = true;
    nvidia.prime = {
      amdgpuBusId = "PCI:5@0:0:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };

  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-partuuid/4d580e45-fb81-4bde-bd5c-44adfff3393a";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "size=2G"
        "mode=755"
      ];
    };
    "/boot" = {
      label = "ESP";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
    "/persist" = {
      label = "nixos";
      fsType = "ext4";
      options = [
        "relatime"
        "lazytime"
      ];
      neededForBoot = true;
    };
  };

  # here because using `fileSystems` blows up boot if mounting fails
  systemd.mounts =
    map
      (label: {
        wantedBy = [ "local-fs.target" ];
        before = [ "local-fs.target" ];

        what = "/dev/disk/by-label/${label}";
        where = "/${label}";

        options = lib.concatStringsSep "," [
          "relatime"
          "lazytime"
        ];
      })
      [
        "d"
        "windows"
      ];
}
