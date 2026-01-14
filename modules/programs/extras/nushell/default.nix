{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.stuff.nushell;
in
{
  options.stuff.nushell = {
    vendors = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
    };
  };

  config = {
    environment = {
      systemPackages = [ pkgs.nushell ];

      sessionVariables.XDG_DATA_DIRS = lib.singleton (
        pkgs.symlinkJoin {
          name = "nushell-vendor-autoload";
          paths = cfg.vendors;
          stripPrefix = "/share/nushell/vendor/autoload";
          postBuild = ''
            files=($out/*)
            mkdir -p $out/share/nushell/vendor/autoload
            mv "''${files[@]}" $out/share/nushell/vendor/autoload
          '';
        }
      );
    };

    my.hjem = {
      xdg.config.files = {
        "foot/foot.ini" = {
          enable = lib.mkDefault false;
          value.main.shell = "nu";
        };

        "nushell/config.nu" = {
          enable = true;
          type = "copy";
          permissions = "600";
          clobber = true;
          source = ./config.nu;
        };
      };
    };
  };
}
