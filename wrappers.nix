{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:
let
  adios = import sources.adios;
  adios-wrappers = import sources.adios-wrappers { inherit adios; };

  root.modules = adios.lib.inject [
    adios-wrappers

    # wrappers directory does not exist yet
    # (adios.lib.importModules { directory = ./wrappers; })
  ];

  tree = adios root {
    options."/nixpkgs" = { inherit pkgs; };
  };
in
builtins.mapAttrs (_name: module: module { }) tree.modules
