{
  myLib,
  ...
}:
{
  imports = [ (myLib.fromRoot "modules/nvidia.nix") ];

  nixpkgs.hostPlatform = "x86_64-linux";

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
  boot.initrd.kernelModules = [ "hid_generic" ];

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
      neededForBoot = true;
    };
    "/boot" = {
      label = "ESP";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
    "/.persist" = {
      label = "nixos";
      fsType = "btrfs";
      options = [
        "relatime"
        "lazytime"
        "compress=lzo"
        "subvol=persist"
      ];
      neededForBoot = true;
    };
    "/d" = {
      label = "nixos";
      fsType = "btrfs";
      options = [
        "relatime"
        "lazytime"
        "compress=lzo"
        "subvol=d"
        "nofail"
      ];
    };
    "/windows" = {
      label = "nixos";
      fsType = "btrfs";
      options = [
        "relatime"
        "lazytime"
        "compress=lzo"
        "subvol=windows"
        "nofail"
      ];
    };
  };
}
