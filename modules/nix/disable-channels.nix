{
  flake.modules.nixos.base = {
    nix.channel.enable = false;
  };

  flake.modules.nixos.iso = {
    system.installer.channel.enable = false;
    nixpkgs.flake.setNixPath = false;
    nixpkgs.flake.setFlakeRegistry = false;
  };
}
