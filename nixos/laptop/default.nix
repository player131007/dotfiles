{ config, lib, pkgs, modulesPath, ... }:

{
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "wl" "i915" ];
    boot.kernelModules = [ "kvm-intel" "wl" ];
    boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

    powerManagement.cpuFreqGovernor = "conservative";

    fileSystems."/d" = {
        device = "/dev/sda4";
        options = [ "uid=player131007" ];
    };


    networking.useDHCP = lib.mkDefault true;

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.firmware = with pkgs; [
        broadcom-bt-firmware
    ];
    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
    };
    hardware.opengl = {
        enable = true;
        extraPackages = with pkgs; [
            intel-media-driver
            intel-vaapi-driver
        ];
    };

}
