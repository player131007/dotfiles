{ lib, pkgs, ... }:
let
  inherit (lib.types) attrsOf submodule submoduleWith;
in
{
  # needed for nh to know which specialisation we are on
  options.specialisation = lib.mkOption {
    type = attrsOf (
      submodule (
        { name, ... }:
        {
          options.configuration = lib.mkOption {
            type = submoduleWith {
              modules = lib.singleton {
                environment.etc."specialisation".text = name;
              };
            };
          };
        }
      )
    );
  };

  config.my.hjem.packages = [ pkgs.nh ];
}
