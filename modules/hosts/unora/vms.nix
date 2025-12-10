{
  config,
  pkgs,
  lib,
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
  services.udev.packages = lib.singleton (
    pkgs.writeTextDir "etc/udev/rules.d/70-kvmfr.rules" /* udev */ ''
      SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
    ''
  );

  virtualisation.libvirtd.qemu.verbatimConfig =
    let
      kvmfr_max_devices = 10; # upstream
      kvmfr_devices = builtins.genList (i: "/dev/kvmfr${toString i}") kvmfr_max_devices;

      cgroup_device_acl =
        # libvirt defaults
        [
          "/dev/null"
          "/dev/full"
          "/dev/zero"
          "/dev/random"
          "/dev/urandom"
          "/dev/ptmx"
          "/dev/kvm"
          "/dev/userfaultfd"
        ]
        ++ kvmfr_devices;
    in
    "cgroup_device_acl = ${builtins.toJSON cgroup_device_acl}";

  my.hjem = {
    packages = [ pkgs.looking-glass-client ];
    stuff.obs.plugins = [ pkgs.obs-studio-plugins.looking-glass-obs ];
  };
}
