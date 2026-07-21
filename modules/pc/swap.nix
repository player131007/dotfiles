{
  boot.zswap.enable = true;
  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
  };

  swapDevices = [
    {
      label = "swap";
    }
  ];
}
