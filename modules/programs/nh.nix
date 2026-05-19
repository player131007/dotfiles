{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.types) attrsOf submodule;
in
{
  # `/etc/specialisation` is read by nh to know which specialisation we are on
  options.specialisation = lib.mkOption {
    type = attrsOf (
      submodule (
        { name, ... }:
        {
          config.configuration = {
            environment.etc."specialisation".text = name;
          };
        }
      )
    );
  };

  config.my.hjem = {
    packages = [ pkgs.nh ];
  };
}
