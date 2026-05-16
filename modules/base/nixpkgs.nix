{ pkgs, ... }:
{
  nix = {
    registry.nixpkgs.to = {
      type = "path";
      path = toString pkgs.path;
    };
    nixPath = [ "nixpkgs=${toString pkgs.path}" ];
  };

  nixpkgs = {
    config.allowUnfree = true;
    flake = {
      setNixPath = false;
      setFlakeRegistry = false;
    };
  };
}
