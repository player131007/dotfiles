{pkgs, ...}: {
  imports = [
    ./win10
  ];

  boot.kernelModules = ["kvm-amd"];

  virtualisation.libvirtd = {
    enable = true;
    qemu.package = pkgs.qemu_kvm;
  };

  # nixvirt
  virtualisation.libvirt = {
    enable = true;
    connections."qemu:///system" = {
      networks = [
        {
          definition = ./network.xml;
          active = true;
        }
      ];
    };
  };
}
