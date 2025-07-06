{
  flake.modules.nixos.base = {
    networking.wireless = {
      enable = false;
      iwd.enable = true;
    };
  };
}
