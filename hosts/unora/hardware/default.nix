{
  nixpkgs.hostPlatform = "x86_64-linux";

  boot.kernelParams = [
    "amd_pstate=active"
    "amdgpu.dcdebugmask=0x40000"
  ];
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
    graphics.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
}
