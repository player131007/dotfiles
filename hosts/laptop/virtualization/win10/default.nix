{pkgs, config, ...}: {
  boot.kernelParams = ["iommu=pt"];

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 ${config.users.users.player131007.name} kvm -"
  ];

  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidia_drm"
    "nvidia_uvm"
    "nvidia_modeset"
  ];

  fileSystems."/windows" = {
    label = "windows";
    fsType = "btrfs";
    options = ["noatime"];
  };

  environment.systemPackages = with pkgs; [virtiofsd];

  virtualisation.libvirt.connections."qemu:///system".domains = [
    {
      definition = ./win10.xml;
    }
  ];
}
