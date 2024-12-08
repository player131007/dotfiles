{
    boot.kernelParams = [ "iommu=pt" ];
    boot.kernelModules = [ "vfio-pci" ];

    boot.extraModprobeConfig = ''
        options vfio-pci ids=10de:25a2,10de:2291
    '';

    boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_uvm" "nvidia_modeset" ];

    fileSystems."/windows" = {
        label = "windows";
        fsType = "btrfs";
        options = [ "nodatacow" "noatime" ];
    };
}
