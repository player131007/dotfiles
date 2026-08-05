{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:
let
  adios = import sources.adios;

  wrappers = adios.lib.importModules { directory = ./wrappers; };

  root.modules = adios.lib.inject [
    (import sources.adios-wrappers { inherit adios; })
    wrappers
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
# only include modules in ./wrappers
builtins.mapAttrs (name: _module: tree.modules.${name}) wrappers
