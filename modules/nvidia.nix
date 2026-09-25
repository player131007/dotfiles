{
  # delete this param at boot time for nvidia
  boot.kernelParams = [ "module_blacklist=nvidia,nvidia_modeset,nvidia_uvm,nvidia_drm" ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
}
