local nixpkgs = "import (import ./npins).nixpkgs {}"
local nixos = [[
let
  pkgs = %s;
  modules = pkgs.lib.evalModules {
    modules = import "${pkgs.path}/nixos/modules/module-list.nix" ++ [{ nixpkgs.hostPlatform = builtins.currentSystem; }];
  };
in modules.options
]]

return {
  settings = {
    nixd = {
      nixpkgs = {
        expr = nixpkgs,
      },
      options = {
        nixos = {
          expr = string.format(nixos, nixpkgs),
        },
      },
    },
  },
}
