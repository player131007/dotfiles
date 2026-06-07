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
    environment.systemPackages =
      let
        vendor_flags =
          let
            vendor = pkgs.symlinkJoin {
              name = "nushell-vendor";
              paths = cfg.vendors;
              stripPrefix = "/share/nushell/vendor/autoload";
            };
          in
          lib.optionals (cfg.vendors != [ ]) [
            "--set-default"
            "NU_VENDOR_AUTOLOAD_DIR"
            "${vendor}"
          ];

        include_path_flags = lib.optionals (cfg.lib_dirs != [ ]) [
          "--append-flag"
          "--include-path"
          "--append-flag"
          (builtins.concatStringsSep "" cfg.lib_dirs)
        ];

        plugins_flags = lib.optionals (cfg.plugins != [ ]) (
          [
            "--append-flag"
            "--plugins"
          ]
          ++ builtins.concatMap (plugin: [
            "--append-flag"
            (lib.getExe plugin)
          ]) cfg.plugins
        );

        finalPackage = pkgs.symlinkJoin {
          inherit (cfg.package) pname version;
          paths = [ cfg.package ];

          nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
          postBuild = ''
            rm $out/bin/nu
            makeWrapper ${lib.getExe cfg.package} $out/bin/nu \
              --inherit-argv0 \
              ${lib.escapeShellArgs (vendor_flags ++ include_path_flags ++ plugins_flags)}
          '';
        };
      in
      [ finalPackage ];

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
