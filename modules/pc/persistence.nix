{
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

  persist = {
    tmpfilesSettings.initrd = {
      "/sysroot/persist/once/etc/machine-id".f = {
        mode = "0444";
        user = "root";
        group = "root";
        argument = "uninitialized";
      };
    };

    at.oncedir = {
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
      storagePath = "/persist/every";
    };
  };
}
