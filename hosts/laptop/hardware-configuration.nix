{ config, lib, pkgs, modulesPath, ... }: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "amdgpu" ];

    boot.kernelModules = [ "kvm-amd" ];

    fileSystems."/d" = {
        device = "/dev/disk/by-uuid/584B-F342";
        fsType = "exfat";
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
            options = [ "defaults" "size=8G" "mode=755" ];
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
        "/tmp" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=tmp" ];
        };
        "/efi" = {
            label = "ESP";
            fsType = "vfat";
            options = [ "umask=0077" ];
        };
    };

    boot.initrd.postDeviceCommands = ''
        mount /dev/disk/by-label/nixos /mnt --mkdir
        btrfs subvol delete /mnt/tmp
        btrfs subvol create /mnt/tmp
        umount /mnt
        rmdir /mnt
    '';

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
