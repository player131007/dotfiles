{ inputs, ... }:
{
  flake.modules.nixos."nixosConfigurations/unora" =
    { lib, config, ... }:
    {
      imports = [ inputs.preservation.nixosModules.default ];

      users.users.player131007.hashedPasswordFile = "/persist/password/player131007";

      preservation =
        let
          mkIf' = cond: content: lib.mkIf cond [ content ];
        in
        {
          enable = true;
          preserveAt = {
            "/persist/once" = {
              commonMountOptions = [ "x-gvfs-hide" ];

              files = [
                {
                  file = "/etc/machine-id";
                  inInitrd = true;
                  how = "symlink"; # is a symlink because we need it to be dangling at first boot
                }
                "/etc/adjtime"
              ];

              directories = lib.mkMerge [
                [
                  "/home"
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
                ]
                (
                  let
                    inherit (config.users.users) greeter;
                  in
                  mkIf' config.services.greetd.enable {
                    directory = "/var/cache/tuigreet";
                    user = greeter.name;
                    group = greeter.group;
                  }
                )
              ];
            };

            "/persist/every" = {
              commonMountOptions = [ "x-gvfs-hide" ];

              directories = lib.mkMerge [
                [ "/var/lib/libvirt" ]
                (mkIf' config.networking.wireless.iwd.enable {
                  directory = "/var/lib/iwd";
                  mode = "0700";
                })
                (mkIf' config.services.upower.enable "/var/lib/upower")
              ];
            };
          };
        };
    };
}
