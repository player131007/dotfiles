{ pkgs, my, ... }:
{
  users.users.${my.name}.extraGroups = [ "libvirtd" ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
    onBoot = "ignore";
    shutdownTimeout = 30;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  persist.at.persistdir.directories = [ "/var/lib/libvirt" ];
}
