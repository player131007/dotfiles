{ config, lib, pkgs, modulesPath, ... }:

{
    imports =
    [
        (modulesPath + "/installer/scan/not-detected.nix")
        ./home.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.extraModulePackages = with config.boot.kernelPackages; [
        lenovo-legion-module
    ];

    boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];

    powerManagement.cpuFreqGovernor = "conservative";

    fileSystems."/d" = {
        device = "/dev/nvme0n1p3";
        options = [ "uid=player131007" ];
    };


    networking.useDHCP = lib.mkDefault true;

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.firmware = with pkgs; [
        linux-firmware
    ];
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
    };
    hardware.opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [
            nvidia-vaapi-driver
        ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        nvidiaSettings = true;
        
        prime = {
            offload = {
                enable = true;
                enableOffloadCmd = true;
            };
            amdgpuBusId = "PCI:5:0:0";
            nvidiaBusId = "PCI:1:0:0";
        };
    };

    zramSwap.enable = true;

    environment.systemPackages = with pkgs; [
        lenovo-legion
    ];
}
