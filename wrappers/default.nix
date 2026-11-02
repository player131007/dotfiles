let
  sources = import ../npins;
in
{
  pkgs ? import sources.nixpkgs { config.allowUnfree = true; },
  adios ? import sources.adios,
  adios-wrappers ? import sources.adios-wrappers { inherit adios; },
  nix-index-cache ? import sources.nix-index-cache { inherit pkgs; },
}:
let
  wrappers = adios.lib.importModules {
    directory = ./.;
    args = adios // {
      assertions.disjoint = a: b: {
        verify = { options }: !(options ? ${a} && options ? ${b});
        explain = { }: "'options.${a}' and 'options.${b}' are disjoint, but both were set";
      };
    };
  };

  root.modules = adios.lib.inject [
    adios-wrappers
    wrappers
  ];

  tree = adios root {
    options = {
      "/nixpkgs" = { inherit pkgs; };
      "/self" = {
        pkgs = import ../pkgs { inherit pkgs; };
        lib = import ../lib.nix { inherit (pkgs) lib; };
      };
      "/nix-index" = {
        inherit (nix-index-cache) nix-index-cache;
      };
    };
  };
in
builtins.intersectAttrs wrappers tree.modules
