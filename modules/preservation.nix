{ inputs, ... }:
{
  flake.modules.nixos.pc =
    { lib, config, ... }:
    let
      inherit (config.stuff) persistDir persistOnceDir;
    in
    {
      imports = [ inputs.preservation.nixosModules.default ];

      options.stuff =
        let
          pathType = lib.types.pathWith {
            absolute = true;
            inStore = false;
          };
        in
        {
          persistDir = lib.mkOption {
            type = pathType;
            description = "directory to persist your stuff";
          };
          persistOnceDir = lib.mkOption {
            type = pathType;
            description = "directory to persist your stuff for one install";
          };
        };

      config = {
        stuff = {
          persistOnceDir = "/persist/once";
          persistDir = "/persist/every";
        };
        preservation = {
          enable = true;
          preserveAt = {
            ${persistOnceDir} = {
              commonMountOptions = [ "x-gvfs-hide" ];
              files = [
                {
                  file = "/etc/machine-id";
                  inInitrd = true;
                  how = "symlink"; # we need it to be dangling at first boot
                }
                "/etc/adjtime"
              ];

              directories = [
                "/var/lib/nixos"
                "/var/lib/systemd"
                {
                  directory = "/nix";
                  inInitrd = true;
                }
                {
                  directory = "/var/log/journal";
                  inInitrd = true;
                  group = "systemd-journal";
                  mode = "2755";
                }
              ];
            };
            ${persistDir}.commonMountOptions = [ "x-gvfs-hide" ];
          };
        };
      };
    };
}
