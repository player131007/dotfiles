{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.modules.nvidia;
in
{
    options.modules.nvidia = {
        enable = mkEnableOption "Nvidia support";
    };

    config = mkIf cfg.enable {
        hardware.nvidia = {
            modesetting.enable = true;
            powerManagement.enable = true;
            powerManagement.finegrained = true;
            nvidiaSettings = true;
            
            prime.offload = {
                enable = true;
                enableOffloadCmd = true;
            };
        };

        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.opengl.extraPackages = [ pkgs.nvidia-vaapi-driver ];
    };
}
