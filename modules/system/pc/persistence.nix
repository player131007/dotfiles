{
  my,
  lib,
  config,
  ...
}:
{
  imports = [ (my.lib.fromRoot "modules/nixos/persistence") ];

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
              inInitrd = true;
              # needs to be dangling at first boot
              method.symlink.createLinkTarget = false;
            }
            "/etc/adjtime"
          ];

          directories = [
            "/var/lib/nixos"
            "/var/lib/systemd"
            {
              directory = "/var/log";
              method.bindmount.extraConfig = {
                mountConfig.LazyUnmount = true;
              };
            }
            {
              directory = "/nix";
              inInitrd = true;
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
