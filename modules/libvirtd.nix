{ pkgs, ... }:
{
  persist.at.persistdir.directories = [ "/var/lib/libvirt" ];
  virtualisation.libvirtd = {
    enable = true;
    onShutdown = "shutdown";
    onBoot = "ignore";
    shutdownTimeout = 30;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
    };
  };

  networking.firewall.extraInputRules = ''
    iifname "virbr0" accept comment "whatever i guess"
  '';
}
