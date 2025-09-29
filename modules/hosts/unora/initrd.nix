{
  flake.modules.nixos."nixosConfigurations/unora" = {
    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usbhid"
      "sd_mod"
      "sdhci_pci"
      "hid_generic"
    ];
    hardware.amdgpu.initrd.enable = true;
  };
}
