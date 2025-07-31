{
  flake.modules.nixos.base = {
    boot.initrd.systemd.enable = true;
  };

  # doesnt work on iso images for now
  # https://github.com/NixOS/nixpkgs/pull/291750
  flake.modules.nixos.iso =
    { lib, ... }:
    {
      boot.initrd.systemd.enable = lib.mkImageMediaOverride false;
    };
}
