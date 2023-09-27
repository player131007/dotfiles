{
    fileSystems."/" =
        { device = "none";
            fsType = "tmpfs";
            options = [ "defaults" "size=2G" "mode=755" ];
        };

    fileSystems."/persist" =
        { label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=persist" ];
            neededForBoot = true;
        };

    fileSystems."/nix" =
        { label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=nix" ];
        };

    fileSystems."/var/log" =
        { label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=log" ];
            neededForBoot = true;
        };

    fileSystems."/boot" =
        { label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=boot" ];
        };

    fileSystems."/home" =
        { label = "nixos";
            fsType = "btrfs";
            options = [ "compress=zstd:5" "noatime" "subvol=home" ];
        };

    fileSystems."/swap" =
        { label = "nixos";
            fsType = "btrfs";
            options = [ "noatime" "subvol=swap" ];
        };

    fileSystems."/efi" =
        { label = "ESP";
            fsType = "vfat";
        };

    swapDevices = [{ device = "/swap/swapfile"; }];

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
