{
  modulesPath,
  config,
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

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };
    "/persist" = {
      label = "nixos";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=persist"
      ];
      neededForBoot = true;
    };
    "/nix" = {
      label = "nixos";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=nix"
      ];
    };
    "/var/log" = {
      label = "nixos";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=log"
      ];
      neededForBoot = true;
    };
    "/home" = {
      label = "nixos";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=home"
      ];
    };
    "/tmp" = {
      label = "nixos";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
        "subvol=tmp"
      ];
    };
    "/boot" = {
      label = "ESP";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
    "/d" = {
      device = "/dev/disk/by-uuid/584B-F342";
      fsType = "exfat";
      options = [
        "uid=${config.users.users.player131007.name}"
        "gid=${config.services.syncthing.group}"
        "umask=002"
      ];
    };
  };

  boot.tmp.cleanOnBoot = true;
}
