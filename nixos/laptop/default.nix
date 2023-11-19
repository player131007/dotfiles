{ config, lib, pkgs, modulesPath, ... }:

{
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.kernelPackages = pkgs.linuxPackages_zen;

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
    };

}
