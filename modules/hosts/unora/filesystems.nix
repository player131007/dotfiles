{ lib, ... }:
{
  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-partuuid/4d580e45-fb81-4bde-bd5c-44adfff3393a";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "size=2G"
        "mode=755"
      ];
    };
    "/boot" = {
      label = "ESP";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };
    "/persist" = {
      label = "nixos";
      fsType = "ext4";
      options = [
        "relatime"
        "lazytime"
      ];
      neededForBoot = true;
    };
  };

  # using `fileSystems` blows up boot if mounting fails (i think)
  systemd.mounts =
    map
      (label: {
        wantedBy = [ "local-fs.target" ];
        before = [ "local-fs.target" ];

        what = "/dev/disk/by-label/${label}";
        where = "/${label}";

        options = lib.concatStringsSep "," [
          "relatime"
          "lazytime"
        ];
      })
      [
        "d"
        "windows"
      ];
}
