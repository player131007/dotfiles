{
  config,
  lib,
  pkgs,
  wrappers,
  ...
}:
{
  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  boot.kernelModules = [ "kvmfr" ];
  boot.extraModprobeConfig = "options kvmfr static_size_mb=32";
  services.udev.packages =
    let
      owner = if config.virtualisation.libvirtd.qemu.runAsRoot then "root" else "qemu-libvirtd";
    in
    pkgs.writeTextDir "etc/udev/rules.d/70-kvmfr.rules" ''
      SUBSYSTEM=="kvmfr", OWNER="${owner}", GROUP="kvm", MODE="0660", TAG+="uaccess"
    ''
    |> lib.singleton;

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
    "cgroup_device_acl = ${builtins.toJSON cgroup_device_acl}"; # rough approximation of the syntax

  my.user.packages = [ wrappers.looking-glass ];
}
