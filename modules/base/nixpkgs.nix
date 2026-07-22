{ lib, pkgs, ... }:
{
  nix = lib.mkIf (lib.path.hasStorePathPrefix pkgs.path) (
    let
      pkgs_path = builtins.storePath pkgs.path;
    in
    {
      registry.nixpkgs.to = {
        type = "path";
        path = pkgs_path;
      };
      nixPath = [ "nixpkgs=${pkgs_path}" ];
    }
  );

  nixpkgs = {
    config.allowUnfree = true;
    flake = {
      setNixPath = false;
      setFlakeRegistry = false;
    };
  };
}
