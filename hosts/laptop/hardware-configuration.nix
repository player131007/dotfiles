{ config, lib, pkgs, modulesPath, inputs, ... }:

{
    imports =
    [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.impermanence.nixosModule
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "amdgpu" ];

    boot.kernelModules = [ "kvm-amd" ];
    boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
    boot.kernelPackages = pkgs.linuxPackages_zen;

    fileSystems."/d" = {
        device = "/dev/disk/by-uuid/1A02-471A";
        options = [ "uid=player131007" ];
    };

    zramSwap.enable = true;

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

    fileSystems = {
        "/" = {
            device = "none";
            fsType = "tmpfs";
            options = [ "defaults" "size=2G" "mode=755" ];
        };
        "/persist" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=persist" ];
            neededForBoot = true;
        };
        "/nix" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=nix" ];
        };
        "/var/log" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=log" ];
            neededForBoot = true;
        };
        "/home" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=home" ];
        };
        "/efi" = {
            label = "ESP";
            fsType = "vfat";
        };
    };

    environment.persistence."/persist" = {
        directories = [
            "/etc/NetworkManager/system-connections"
        ];
        files = [
            "/etc/adjtime"
            "/etc/machine-id"
            "/etc/resolv.conf"
        ];
    };

}
