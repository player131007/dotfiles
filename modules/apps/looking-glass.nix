{
  flake.modules.nixos.pc = {
    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 player131007 qemu-libvirtd -"
    ];
  };

  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.looking-glass-client ];
      programs.obs-studio.plugins = [ pkgs.obs-studio-plugins.looking-glass-obs ];
    };
}
