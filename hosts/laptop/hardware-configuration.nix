{ pkgs, modulesPath, ... }: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "amdgpu" "vfio-pci" ];

    boot.kernelParams = [ "iommu=pt" "vfio-pci.ids=10de:25a2,10de:2291"];
    boot.kernelModules = [ "kvm-amd" ];

    hardware = {
        cpu.amd.updateMicrocode = true;

        enableRedistributableFirmware = false;
        wirelessRegulatoryDatabase = true;
        firmware = with pkgs; [
            linux-firmware
        ];

        bluetooth = {
            enable = true;
            powerOnBoot = false;
        };

        graphics.enable = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        nvidiaSettings = false;

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
            options = [ "compress=zstd" "noatime" "subvol=persist" ];
            neededForBoot = true;
        };
        "/nix" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd" "noatime" "subvol=nix" ];
        };
        "/var/log" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd" "noatime" "subvol=log" ];
            neededForBoot = true;
        };
        "/home" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd" "noatime" "subvol=home" ];
        };
        "/tmp" = {
            label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd" "noatime" "subvol=tmp" ];
        };
        "/efi" = {
            label = "ESP";
            fsType = "vfat";
            options = [ "umask=0077" ];
        };
        "/d" = {
            device = "/dev/disk/by-uuid/584B-F342";
            fsType = "exfat";
            options = [ "uid=player131007" ];
        };
        "/windows" = {
            label = "windows";
            fsType = "exfat";
        };
    };

    boot.initrd.postDeviceCommands = ''
        mkdir /mnt
        mount /dev/disk/by-label/nixos /mnt
        btrfs subvol delete /mnt/tmp --commit-after
        btrfs subvol create /mnt/tmp
        umount /mnt
        rmdir /mnt
    '';
}
