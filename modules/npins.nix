{ fromRoot, ... }:
{
  flake.modules.generic = {
    npins = {
      _module.args.npins = import (fromRoot "npins/default.nix");
    };
    npins-nixpkgs =
      { pkgs, ... }:
      {
        _module.args.npins' = pkgs.callPackage (fromRoot "npins/fetch-with-nixpkgs.nix");
      };
  };
}
