{
  flake.modules.nixos.base = {
    nixpkgs.config.allowUnfree = true;
  };
}
