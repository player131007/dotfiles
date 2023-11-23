{ config, lib, pkgs, modulesPath, ... }:

{
    imports =
    [
        (modulesPath + "/installer/scan/not-detected.nix")
        ./persist.nix
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "amdgpu" ];

    boot.kernelModules = [ "kvm-amd" ];
    boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
    boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.extraModulePackages = with config.boot.kernelPackages; [
        lenovo-legion-module
    ];

    fileSystems."/d" = {
        device = "/dev/nvme0n1p3";
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

    modules.nvidia.enable = true;
    hardware.nvidia.prime = {
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
    };

    fileSystems."/" = {
        device = "none";
        fsType = "tmpfs";
        options = [ "defaults" "size=2G" "mode=755" ];
    };

    fileSystems."/persist" = {
        label = "nixos";
        fsType = "btrfs";
        options = [ "compress=zstd:5" "noatime" "subvol=persist" ];
        neededForBoot = true;
    };

    fileSystems."/nix" = {
        label = "nixos";
        fsType = "btrfs";
        options = [ "compress=zstd:5" "noatime" "subvol=nix" ];
    };

    fileSystems."/var/log" = {
        label = "nixos";
        fsType = "btrfs";
        options = [ "compress=zstd:5" "noatime" "subvol=log" ];
        neededForBoot = true;
    };

    fileSystems."/boot" = {
        label = "nixos";
        fsType = "btrfs";
        options = [ "compress=zstd:5" "noatime" "subvol=boot" ];
    };

    fileSystems."/home" = {
        label = "nixos";
        fsType = "btrfs";
        options = [ "compress=zstd:5" "noatime" "subvol=home" ];
    };

    fileSystems."/efi" = {
        label = "ESP";
        fsType = "vfat";
    };
}
