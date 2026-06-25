{ lib, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    settings.global.log_filter = "^([^e]|e[^x]|ex[^p]|exp[^o]|expo[^r]|expor[^t]).*$";

    nix-direnv.enable = true;
  };

  environment.systemPackages = lib.singleton (
    pkgs.writeTextDir "share/nushell/vendor/autoload/direnv.nu" ''
      # Initialize the PWD hook as an empty list if it doesn't exist
      $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

      $env.config.hooks.env_change.PWD ++= [{||
        direnv export json | from json | default {} | items {|key, value|
          {
            $key: (if $key in $env.ENV_CONVERSIONS {
              do ($env | get (["ENV_CONVERSIONS", $key, "from_string"] | into cell-path)) $value
            } else $value)
          }
        } | into record | load-env
      }] ''
  );
}
