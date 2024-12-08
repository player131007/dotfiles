{ pkgs, modulesPath, config, ... }: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ "amdgpu" ];

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

        amdgpu.amdvlk.enable = true;
        graphics.enable = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = true;
        nvidiaSettings = false;

        # doesnt work if not set explicitly
        open = true;

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
        "/boot" = {
            label = "ESP";
            fsType = "vfat";
            options = [ "umask=0077" ];
        };
        "/d" = {
            device = "/dev/disk/by-uuid/584B-F342";
            fsType = "exfat";
            options = [ "uid=player131007" "gid=${config.services.syncthing.group}" "umask=002" ];
        };
    };

    systemd.services = {
        reset-tmp = {
            description = "Reset /tmp";

            wantedBy = [ "tmp.mount" ];
            before = [ "tmp.mount" ];
            after = [ "blockdev@dev-disk-by\\x2dlabel-nixos.target" ];

            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            path = with pkgs; [ util-linux btrfs-progs ];
            script = ''
                mkdir -p /mnt
                mount /dev/disk/by-label/nixos /mnt
                if [ -e /mnt/tmp ]; then
                    btrfs subvolume delete /mnt/tmp --commit-after
                fi
                btrfs subvolume create /mnt/tmp
                umount /mnt
                rmdir /mnt
            '';
        };
    };
}
