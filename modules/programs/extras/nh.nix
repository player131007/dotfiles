{
  lib,
  pkgs,
  myLib,
  config,
  ...
}:
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

  config.my.hjem = {
    packages = [ pkgs.nh ];
    environment.sessionVariables = {
      NH_FILE = toString (myLib.fromRoot "nixos.nix");
      NH_ATTRP = config.networking.hostName;
    };
  };
}
