{
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
    "sdhci_pci"
    "hid_generic"
  ];
  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware = {
    cpu.amd.updateMicrocode = true;

    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    amdgpu.amdvlk.enable = true;
    graphics.enable = true;
  };

  # blacklist nvidia for GPU passthrough
  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_uvm"
    "nvidia_modeset"
  ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    nvidiaSettings = false;

    open = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      amdgpuBusId = "PCI:5:0:0";
      nvidiaBusId = "PCI:1:0:0";
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
      options = [ "relatime" "lazytime" ];
      neededForBoot = true;
    };
  };

  systemd.mounts = lib.singleton {
    what = "/dev/disk/by-label/d";
    where = "/d";
    type = "ext4";
    options = lib.concatStringsSep "," [ "relatime" "lazytime" ];
  };
  systemd.automounts = lib.singleton {
    where = "/d";
  };

  boot.tmp.cleanOnBoot = true;
}
