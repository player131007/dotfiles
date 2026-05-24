{ lib, pkgs, ... }:
{
  nix =
    let
      pkgs_path =
        if lib.path.hasStorePathPrefix pkgs.path then
          builtins.storePath pkgs.path
        else
          # bailing out, you're on your own.
          toString pkgs.path;
    in
    {
      registry.nixpkgs.to = {
        type = "path";
        path = pkgs_path;
      };
      nixPath = [ "nixpkgs=${pkgs_path}" ];
    };

  nixpkgs = {
    config.allowUnfree = true;
    flake = {
      setNixPath = false;
      setFlakeRegistry = false;
    };
  };
}
