{
  # doesnt work on iso images for now
  # https://github.com/NixOS/nixpkgs/pull/291750
  flake.modules.nixos.pc = {
    boot.initrd.systemd.enable = true;
  };
}
