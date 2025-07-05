{ self, ... }:
{
  flake.modules.nixos.base = {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      self.overlays._7zz-maybe-unfree
    ];
  };
}
