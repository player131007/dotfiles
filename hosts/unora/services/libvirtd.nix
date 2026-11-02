{ pkgs, ... }:
{
  # windows vm takes the gpu, and unplugging it while the system is running is too bothersome
  boot.kernelParams = [ "module_blacklist=nvidia,nvidia_modeset,nvidia_uvm,nvidia_drm" ];

  persist.at.persistdir.directories = [ "/var/lib/libvirt" ];
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

  networking.firewall.extraInputRules = ''
    iifname "virbr0" accept comment "whatever i guess"
  '';
}
