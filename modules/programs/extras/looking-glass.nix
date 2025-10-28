{
  config,
  pkgs,
  lib,
  ...
}:
{
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

  hjem.extraModules = lib.singleton {
    packages = [ pkgs.looking-glass-client ];
    stuff.obs.plugins = [ pkgs.obs-studio-plugins.looking-glass-obs ];
  };
}
