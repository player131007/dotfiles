{
  config,
  lib,
  pkgs,
  myPkgs,
  ...
}:
let
  cfg = config.stuff.nushell;

  inherit (lib.types) listOf package pathInStore;
in
{
  options.stuff.nushell = {
    vendors = lib.mkOption {
      type = listOf package;
      default = [ ];
    };

    plugins = lib.mkOption {
      type = listOf package;
      default = [ ];
    };

    lib_dirs = lib.mkOption {
      type = listOf pathInStore;
      default = [ ];
    };

    package = lib.mkPackageOption pkgs "nushell" { };
  };

  config = {
    environment = {
      sessionVariables = {
        NU_VENDOR_AUTOLOAD_DIR = pkgs.symlinkJoin {
          name = "nushell-vendor";
          paths = cfg.vendors;
          stripPrefix = "/share/nushell/vendor/autoload";
        };
      };

      systemPackages = [ cfg.package ];
    };
    stuff.nushell.vendors = lib.singleton (
      pkgs.writeTextDir "share/nushell/vendor/autoload/00-search-paths.nu" /* nu */ ''
        const NU_PLUGIN_DIRS = [
          ${lib.pipe cfg.plugins [
            (map (p: "${p}/bin"))
            lib.concatLines
          ]}
          ...$NU_PLUGIN_DIRS
        ]

        const NU_LIB_DIRS = [
          ${lib.concatLines cfg.lib_dirs}
          ...$NU_LIB_DIRS
        ]
      ''
    );

    stuff.nushell.plugins = [ myPkgs.nushellPlugins.bexpand ];
    stuff.nushell.lib_dirs = [ "${./nushell-lib}" ];

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
          source = ./config.nu;
        };
      };
    };
  };
}
