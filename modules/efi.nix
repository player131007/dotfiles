{
  flake.modules.nixos.efi = {
    boot.loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        edk2-uefi-shell.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
