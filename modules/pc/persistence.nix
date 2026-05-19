{
  config,
  lib,
  myLib,
  ...
}:
{
  imports = [ (myLib.fromRoot "modules/persistence") ];

  persist = lib.mkMerge [
    (
      let
        commonMountOptions = [
          "x-gvfs-hide"
          "x-gdu.hide"
          "X-fstrim.notrim"
        ];
      in
      {
        at.oncedir = {
          inherit commonMountOptions;
          storagePath = "/persist/once";
          files = [
            {
              file = "/etc/machine-id";
              early = true;
              mode = "0444";
              tmpfilesSettings.f.argument = "uninitialized";
              method.symlink.createLinkTarget = true;
            }
            "/etc/adjtime"
          ];

          directories = [
            "/var/lib/nixos"
            {
              directory = "/var/lib/systemd";
              early = true;
            }
            {
              directory = "/var/log";
              method.bindmount.extraConfig = {
                mountConfig.LazyUnmount = true;
              };
            }
            {
              directory = "/nix";
              early = true;
              method.bindmount.mountOptions = [ "slave" ];
            }
          ];
        };

        at.persistdir = {
          inherit commonMountOptions;
          storagePath = "/persist/every";
        };
      }
    )

    # i don't know where to put this
    (lib.mkIf config.networking.wireless.iwd.enable {
      at.persistdir.directories = lib.singleton {
        directory = "/var/lib/iwd";
        mode = "0700";
      };
    })
  ];
}
