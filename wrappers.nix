{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:
let
  adios = import sources.adios;
  adios-wrappers = import sources.adios-wrappers { inherit adios; };

  root.modules = adios.lib.inject [
    adios-wrappers

    (adios.lib.importModules { directory = ./wrappers; })
  ];

  tree = adios root {
    options = {
      "/nixpkgs" = { inherit pkgs; };
      "/self" = {
        pkgs = import ./packages.nix { inherit pkgs; };
        lib = import ./lib.nix { inherit (pkgs) lib; };
      };
      "/nix-index" = {
        inherit (import sources.nix-index-cache { inherit pkgs; }) nix-index-cache;
      };
    };
  };
in
builtins.mapAttrs (_name: module: module { }) tree.modules
