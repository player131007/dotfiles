{
  flake.modules.nixos.nvidia = {
    specialisation.nvidia.configuration = {
      services.xserver.videoDrivers = [ "nvidia" ];
    };

    boot.blacklistedKernelModules = [
      "nouveau"
      "nvidiafb"
    ];
  };
}
