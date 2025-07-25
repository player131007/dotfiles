{
  flake.modules.nixos."nixosConfigurations/unora" =
    { pkgs, ... }:
    {
      users.users.player131007.extraGroups = [ "libvirtd" ];

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
        hooks.qemu = {
          win11-refresh-drive = pkgs.writeShellScript "win11-refresh-drive" ''
            set -euo pipefail

            DRIVE="/windows/win11.qcow2"
            GUEST_NAME="$1"
            OPERATION="$2"
            SUB_OPERATION="$3"

            if [ ! -e /windows/a ]; then
              if [ "$GUEST_NAME" = "win11" -a "$OPERATION" = "prepare" -a "$SUB_OPERATION" = "begin" ]; then
                qemu-img create -f qcow2 -b ./base.qcow2 -F qcow2 $DRIVE
                chown qemu-libvirtd $DRIVE
              elif [ "$GUEST_NAME" = "win11" -a "$OPERATION" = "release" -a "$SUB_OPERATION" = "end" ]; then
                mv $DRIVE $DRIVE.bak
              fi
            fi
          '';
        };
      };
    };
}
