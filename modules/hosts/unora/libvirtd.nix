{
  flake.modules.nixos."nixosConfigurations/unora" =
    { pkgs, config, ... }:
    {
      users.users.player131007.extraGroups = [ "libvirtd" ];

      networking.firewall.extraCommands = # bash
        ''
          iptables -A nixos-fw -i virbr0 -p udp -s 0.0.0.0 --sport 68 -d 255.255.255.255 --dport 67 -j nixos-fw-accept
          iptables -A nixos-fw -i virbr0 -p udp -s 192.168.122.0/24 --sport 68 -d 192.168.122.1 --dport 67 -j nixos-fw-accept
        '';

      programs.virt-manager.enable = true;
      virtualisation.libvirtd = {
        enable = true;
        onShutdown = "shutdown";
        onBoot = "ignore";
        shutdownTimeout = 30;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = false;
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };

      preservation.preserveAt.${config.stuff.persistDir}.directories = [ "/var/lib/libvirt" ];
    };
}
