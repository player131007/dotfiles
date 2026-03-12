{
  specialisation.nvidia.configuration = {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia.prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidiafb"
    "nova_core"
  ];

  hardware.nvidia = {
    open = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
  };
}
