{ lib, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    settings.global.hide_env_diff = true;

    nix-direnv.enable = true;
  };

  environment.systemPackages = lib.singleton (
    pkgs.writeTextDir "share/nushell/vendor/autoload/direnv.nu" ''
      $env.config.hooks.pre_prompt = $env.config.hooks.pre_prompt? | default [] | append {||
        direnv export json
        | from json
        | default {}
        | transpose key value
        | update value {|row|
            if $row.key in $env.ENV_CONVERSIONS {
              let path = [ ENV_CONVERSIONS $row.key from_string ] | into cell-path
              do ($env | get $path) $row.value
            } else $row.value
          }
        | transpose --as-record --header-row | into record # why
        | load-env
      }
    ''
  );
}
