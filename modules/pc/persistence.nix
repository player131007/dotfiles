{
  lib,
  myLib,
  ...
}:
{
  imports = [ (myLib.fromRoot "modules/persistence") ];

  persist =
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
    };
}
