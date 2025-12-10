{
  config,
  pkgs,
  username,
  ...
}:
{
  users.users.${username}.extraGroups = [ "libvirtd" ];

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

  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  boot.kernelModules = [ "kvmfr" ];
  boot.extraModprobeConfig = "options kvmfr static_size_mb=32";
  services.udev.extraRules =
    let
      owner = if config.virtualisation.libvirtd.qemu.runAsRoot then "root" else "qemu-libvirtd";
    in
    ''
      SUBSYSTEM=="kvmfr", OWNER="${owner}", GROUP="users", MODE="0660"
    '';

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm",
      "/dev/userfaultfd",
      "/dev/kvmfr0"
    ]
  '';

  my.hjem = {
    packages = [ pkgs.looking-glass-client ];
    stuff.obs.plugins = [ pkgs.obs-studio-plugins.looking-glass-obs ];
  };
}
