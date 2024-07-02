{ pkgs, config, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./apps.nix
    ];

    users.users.player131007 = {
        isNormalUser = true;
        extraGroups = [ "wheel" "audio" "input" "libvirtd" ];
        hashedPasswordFile = "/persist/password/player131007";
    };

    nix.channel.enable = false;
    nix.settings.nix-path = config.nix.nixPath;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config = {
        allowUnfree = true;
        cudaSupport = true;
        packageOverrides = prev: {
            gitMinimal = prev.gitMinimal.override {
                withManual = true;
                doInstallCheck = false;
            };
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    networking = {
        hostName = "laptop";

        useNetworkd = true;
        dhcpcd.enable = false;
        wireless.iwd.enable = true;
        nameservers = [
            "1.1.1.1#cloudflare-dns.com"
            "2606:4700:4700::1111#cloudflare-dns.com"
        ];
    };

    services.resolved = {
        enable = true;
        fallbackDns = [
            "9.9.9.9#dns.quad9.net"
            "2620:fe::9#dns.quad9.net"
            "8.8.8.8#dns.google"
            "2001:4860:4860::8888#dns.google"
        ];
    };

    systemd.tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 player131007 kvm -"
    ];

    systemd.network = {
        enable = true;
        wait-online.enable = false;
        networks = {
            wired = {
                matchConfig = {
                    Type = "ether";
                    Kind = "!*";
                };
                DHCP = "yes";
                dhcpV4Config.RouteMetric = 100;
                ipv6AcceptRAConfig.RouteMetric = 100;
            };
            wireless = {
                matchConfig.Type = "wlan";
                DHCP = "yes";
                dhcpV4Config.RouteMetric = 600;
                ipv6AcceptRAConfig.RouteMetric = 600;
            };
        };
    };

    system.activationScripts = {
        run-nix-index.text = ''
            echo -e '\033[31;1m!!!\033[0m' remember to run nix-index if u updated nixpkgs
        '';
    };

    console = {
        packages = [ pkgs.powerline-fonts ];
        font = "ter-powerline-v14b";
    };

    security = {
        sudo = {
            enable = true;
            execWheelOnly = true;
            extraConfig = ''
                Defaults lecture=never
            '';
        };
        rtkit.enable = true;
    };

    services = {
        pipewire = {
            enable = true;
            alsa.enable = true;
        };
        greetd = {
            enable = true;
            vt = 2;
            settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet -t -d -r --remember-user-session --asterisks --user-menu";
        };
    };

    xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
        ];
        config.common = {
            default = [ "hyprland" "gtk" ];
        };
    };

    virtualisation.libvirtd = {
        enable = true;
        qemu.package = pkgs.qemu_kvm;
        hooks.qemu = {
            gpu-hotswap = pkgs.writeShellScript "gpu-hotswap" ''
                set -u
                die() {
                    echo "$1" >&2
                    exit 1
                }

                bind() {
                    local dev="$1"
                    local drv_path="$2"
                    echo -n "$dev" > "$drv_path/bind" || die "Failed to bind $dev to $drv_path"
                }

                unbind() {
                    local dev="$1"
                    local drv_path="$2"
                    echo -n "$dev" > "$drv_path/unbind" || die "Failed to unbind $dev from $drv_path"
                }

                if [ "$2" == "prepare" ]; then
                    unbind "0000:01:00.0" /sys/bus/pci/drivers/nvidia
                    unbind "0000:01:00.1" /sys/bus/pci/drivers/snd_hda_intel
                    bind "0000:01:00.0" /sys/bus/pci/drivers/vfio-pci
                    bind "0000:01:00.1" /sys/bus/pci/drivers/vfio-pci
                elif [ "$2" == "release" ]; then
                    unbind "0000:01:00.0" /sys/bus/pci/drivers/vfio-pci
                    unbind "0000:01:00.1" /sys/bus/pci/drivers/vfio-pci
                    bind "0000:01:00.0" /sys/bus/pci/drivers/nvidia
                    bind "0000:01:00.1" /sys/bus/pci/drivers/snd_hda_intel
                fi
            '';
        };
    };

    zramSwap.enable = true;

    boot = {
        loader = {
            systemd-boot.enable = true;
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/efi";
            };
        };
        kernel.sysctl = {
            # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
            "vm.swappiness" = 180;
            "vm.watermark_boost_factor" = 0;
            "vm.watermark_scale_factor" = 125;
            "vm.page-cluster" = 0;
        };
    };

    time.timeZone = "Asia/Ho_Chi_Minh";

    environment.persistence."/persist" = {
        directories = [
            "/var/lib/iwd"
            "/var/lib/libvirt"
            { directory = "/var/cache/tuigreet"; user = "greeter"; group = "greeter"; }
        ];
        files = [
            "/etc/adjtime"
            "/etc/machine-id"
        ];
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

    system.stateVersion = "23.05";
}
