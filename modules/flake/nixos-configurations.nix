{ lib, config, ... }:
let
  prefix = "nixosConfigurations/";
in
{
  flake.nixosConfigurations = lib.pipe (config.flake.modules.nixos or { }) [
    (lib.filterAttrs (name: _: lib.hasPrefix prefix name))
    (lib.mapAttrs' (
      name: module:
      let
        hostName = lib.removePrefix prefix name;
      in
      {
        name = hostName;
        value = lib.nixosSystem {
          modules = [
            module
            { networking = { inherit hostName; }; }
          ];
        };
      }
    ))
  ];
}
