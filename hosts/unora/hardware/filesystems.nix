{
  boot.initrd.luks.devices.cryptroot = {
    device = "/dev/disk/by-partuuid/b98a1254-c974-49a7-ad0f-d0a87bdbc967";
    allowDiscards = true;
    bypassWorkqueues = true;
  };

  fileSystems =
    let
      common_opts = [
        "relatime"
        "lazytime"
        "compress=lzo"
      ];
    in
    {
      "/" = {
        device = "tmpfs";
        fsType = "tmpfs";
        options = [
          "size=2G"
          "mode=755"
        ];
        neededForBoot = true;
      };
      "/boot" = {
        label = "ESP";
        fsType = "vfat";
        options = [ "umask=0077" ];
      };
      "/.persist" = {
        label = "nixos";
        fsType = "btrfs";
        options = common_opts ++ [ "subvol=persist" ];
        neededForBoot = true;
      };
      "/d" = {
        label = "nixos";
        fsType = "btrfs";
        options = common_opts ++ [
          "subvol=d"
          "nofail"
        ];
      };
    };
}
