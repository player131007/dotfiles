{
  flake.modules.nixos."nixosConfigurations/unora" =
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

      systemd.mounts = [
        {
          what = "/dev/disk/by-label/d";
          where = "/d";
          type = "ext4";
          options = lib.concatStringsSep "," [
            "relatime"
            "lazytime"
          ];
        }
        {
          what = "/dev/disk/by-label/windows";
          where = "/windows";
          type = "ext4";
          options = lib.concatStringsSep "," [
            "relatime"
            "lazytime"
          ];
        }
      ];
      systemd.automounts = [
        {
          where = "/d";
          wantedBy = [ "local-fs.target" ];
        }
        {
          where = "/windows";
          wantedBy = [ "local-fs.target" ];
        }
      ];
    };
}
