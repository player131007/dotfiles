{ pkgs, ... }:
{
    imports = [
        ./win10
    ];

    boot.kernelModules = [ "kvm-amd" ];

    systemd.tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 player131007 kvm -"
    ];

    virtualisation.libvirtd = {
        enable = true;
        qemu.package = pkgs.qemu_kvm;
    };
}
