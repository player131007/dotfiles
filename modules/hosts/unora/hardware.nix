{
  flake.modules.nixos."nixosConfigurations/unora" = {
    hardware = {
      cpu.amd.updateMicrocode = true;
      enableRedistributableFirmware = true;
      bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
      graphics.enable = true;
    };
  };
}
