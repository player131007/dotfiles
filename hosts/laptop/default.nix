{ pkgs, config, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./apps.nix
    ];

    scheme = ../../rose-pine.yaml;

    users.mutableUsers = false;
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
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    services.fwupd.enable = true;

    networking = {
        hostName = "laptop";

        useNetworkd = true;
        dhcpcd.enable = false;
        wireless.iwd.enable = true;
        nameservers = [
            "1.1.1.1#cloudflare-dns.com"
            "2606:4700:4700::1111#cloudflare-dns.com"
            "9.9.9.9#dns.quad9.net"
            "2620:fe::9#dns.quad9.net"
            "8.8.8.8#dns.google"
            "2001:4860:4860::8888#dns.google"
        ];
    };

    services.resolved = {
        enable = true;
        dnssec = "true";
        fallbackDns = [];
    };

    systemd.tmpfiles.rules = [
        "f /dev/shm/looking-glass 0660 player131007 kvm -"
    ];

    systemd.network = {
        enable = true;
        wait-online.enable = false;
    };

    system.activationScripts = {
        run-nix-index.text = ''
            echo -e '\033[31;1m!!!\033[0m' remember to run nix-index if u updated nixpkgs
        '';
    };

    console.font = "${pkgs.terminus_font}/share/consolefonts/ter-v16b.psf.gz";

    security = {
        sudo = {
            enable = true;
            execWheelOnly = true;
            extraConfig = ''
                Defaults lecture=never
            '';
        };
        # rtkit.enable = true;
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
        upower = {
            enable = true;
        };
        syncthing = {
            enable = true;
            openDefaultPorts = true;
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
    };

    zramSwap.enable = true;

    boot = {
        initrd.systemd.enable = true;
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
        kernel.sysctl = {
            "kernel.dmesg_restrict" = 0;

            # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
            "vm.swappiness" = 180;
            "vm.watermark_boost_factor" = 0;
            "vm.watermark_scale_factor" = 125;
            "vm.page-cluster" = 0;
        };
    };

    time.timeZone = "Asia/Ho_Chi_Minh";

    environment.persistence."/persist" = {
        hideMounts = true;
        directories = [
            "/var/lib/iwd"
            "/var/lib/libvirt"
            "/var/lib/nixos"
            { directory = "/var/cache/tuigreet"; user = "greeter"; group = "greeter"; }
            ( with config.services.syncthing; { directory = dataDir; inherit user group; } )
        ];
        files = [
            "/etc/adjtime"
            "/etc/machine-id"
        ];
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

    system.stateVersion = "23.05";
}
