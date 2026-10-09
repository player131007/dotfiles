{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:
let
  adios = import sources.adios;

  wrappers = adios.lib.importModules {
    directory = ./wrappers;
    args = adios // {
      assertions.disjoint = a: b: {
        verify = { options }: !(options ? ${a} && options ? ${b});
        explain = { }: "'options.${a}' and 'options.${b}' are disjoint, but both were set";
      };
    };
  };

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
builtins.intersectAttrs wrappers tree.modules
