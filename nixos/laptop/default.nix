{ config, lib, pkgs, modulesPath, ... }:

{
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

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

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    hardware.firmware = with pkgs; [
        broadcom-bt-firmware
    ];
}
