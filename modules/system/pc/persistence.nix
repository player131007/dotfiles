{
  myLib,
  lib,
  config,
  ...
}:
let
  inherit (builtins) concatStringsSep;
in
{
  imports = [ (myLib.fromRoot "modules/nixos/persistence") ];

  boot.initrd.systemd.mounts =
    let
      nixStore = toString (/sysroot + config.persist.at.oncedir.storagePath + "/nix/store");
    in
    lib.singleton {
      wantedBy = [ "initrd.target" ];
      before = [
        "initrd.target"
        config.boot.initrd.systemd.targets.persistence.name
      ];

      what = nixStore;
      where = nixStore;
      options = concatStringsSep "," ([ "bind" ] ++ config.boot.nixStoreMountOpts);
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
        at.oncedir = {
          inherit commonMountOptions;
          storagePath = "/persist/once";
          files = [
            {
              file = "/etc/machine-id";
              early = true;
              mode = "0444";
              extraTmpfiles.argument = "uninitialized";
              method.symlink.createLinkTarget = true;
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
              early = true;
              method.bindmount.extraConfig = {
                options = "private";
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
