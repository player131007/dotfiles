{ config, ... }:
{
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
}
