{ pkgs, ... }:
{
    boot.kernelParams = [ "iommu=pt" ];
    boot.kernelModules = [ "vfio-pci" ];

    boot.extraModprobeConfig = ''
        options vfio-pci ids=10de:25a2,10de:2291
    '';

    systemd.tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 player131007 kvm -"
    ];

    boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_uvm" "nvidia_modeset" ];

    fileSystems."/windows" = {
        label = "windows";
        fsType = "btrfs";
        options = [ "nodatacow" "noatime" ];
    };

    environment.systemPackages = with pkgs; [ virtiofsd ];

    virtualisation.libvirt.connections."qemu:///system".domains = [
        {
            definition = ./win10.xml;
        }
    ];
}
