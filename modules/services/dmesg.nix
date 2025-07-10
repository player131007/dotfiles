{
  flake.modules.nixos.base = {
    boot.kernel.sysctl."kernel.dmesg_restrict" = 0;
  };
}
