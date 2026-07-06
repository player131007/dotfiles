{
  config,
  lib,
  myLib,
  ...
}:
{
  imports = [ (myLib.fromRoot "modules/persistence") ];

  environment.etc = {
    machine-id = {
      mode = "direct-symlink";
      source = "/persist/once/etc/machine-id";
    };
    adjtime.text = ''
      0.0 0 0
      0
      UTC
    '';
  };

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
        tmpfilesSettings.initrd = {
          "/sysroot/persist/once/etc/machine-id".f = {
            mode = "0444";
            user = "root";
            group = "root";
            argument = "uninitialized";
          };
        };

        at.oncedir = {
          inherit commonMountOptions;
          storagePath = "/persist/once";
          directories = [
            "/var/lib/nixos"
            {
              directory = "/var/lib/systemd";
              early = true;
            }
            {
              directory = "/var/log";
              method.bindmount.extraConfig = {
                conflicts = lib.mkForce [ ];
                before = lib.mkForce [ "persistence.target" ];
              };
            }
            {
              directory = "/nix";
              early = true;
              method.bindmount = {
                mountOptions = [ "slave" ];
                extraConfig = {
                  conflicts = lib.mkForce [ ];
                  before = lib.mkForce [ "persistence.target" ];
                };
              };
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
