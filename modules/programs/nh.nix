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
    type =
      (
        { name, ... }:
        {
          config.configuration = {
            environment.etc."specialisation".text = name;
          };
        }
      )
      |> submodule
      |> attrsOf;
  };

  config.my.user.packages = [ pkgs.nh ];
}
