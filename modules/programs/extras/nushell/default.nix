{
  config,
  lib,
  pkgs,
  myPkgs,
  ...
}:
let
  cfg = config.stuff.nushell;

  inherit (lib.types) listOf package;
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

    package = lib.mkPackageOption pkgs "nushell" { };
  };

  config = {
    # prevent plugins from getting garbage collected
    system.extraDependencies = cfg.plugins;

    environment.systemPackages =
      let
        vendor = pkgs.symlinkJoin {
          name = "nushell-vendor";
          paths = cfg.vendors;
          stripPrefix = "/share/nushell/vendor/autoload";
        };

        plugin-config =
          pkgs.runCommandLocal "nushell-plugin.msgpackz"
            {
              __structuredAttrs = true;
              plugins = map lib.getExe cfg.plugins;
            }
            ''
              ${lib.getExe cfg.package} \
                --plugin-config $out \
                -c "open --raw \$env.NIX_ATTRS_JSON_FILE | from json | get plugins | each {|p| plugin add \$p }; exit"
            '';
      in
      lib.singleton (
        pkgs.symlinkJoin {
          name = "nushell";
          paths = [ cfg.package ];

          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          postBuild = ''
            wrapProgram $out/bin/nu \
              --set NU_VENDOR_AUTOLOAD_DIR ${vendor} \
              --add-flag --plugin-config=${plugin-config}
          '';
        }
      );

    stuff.nushell.plugins = [ myPkgs.nushellPlugins.bexpand ];

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
