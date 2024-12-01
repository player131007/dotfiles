{ pkgs, config, lib, ... }:
{
    imports = [
        ./hardware-configuration.nix
        ./apps.nix
    ];

    environment.sessionVariables = {
        XDG_CONFIG_HOME = "$HOME/.config";
    };

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

    # it keeps trying to save /etc/machine-id
    systemd.services.systemd-machine-id-commit.enable = false;

    systemd.network = {
        enable = true;
        wait-online.enable = false;
    };

    system.activationScripts = {
        run-nix-index.text = ''
            echo -e '\033[31;1m!!!\033[0m' remember to run nix-index if u updated nixpkgs
        '';
    };

    console.colors = with config.scheme; [
        base00
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base05
        base11
        base12
        base14
        base13
        base16
        base17
        base15
        base07
    ];

    security = {
        sudo = {
            enable = true;
            execWheelOnly = true;
            extraConfig = ''
                Defaults lecture=never
            '';
        };
    };

    services = {
        pipewire = {
            enable = true;
            alsa.enable = true;
        };
        greetd = {
            enable = true;
            vt = 2;
            settings.default_session.command = "${lib.getExe pkgs.greetd.tuigreet} -t -d -r --remember-user-session --asterisks --user-menu";
        };
        upower = {
            enable = true;
        };
        syncthing = {
            enable = true;
            openDefaultPorts = true;
        };
        fwupd.enable = true;
        logind.lidSwitch = "ignore";
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

    # https://nixos.org/manual/nixos/stable/#ch-system-state
    environment.persistence."/persist" =
    let
        getEnableOption = parts: lib.foldl' (acc: x: acc.${x}) config (parts ++ [ "enable" ]);
    in {
        hideMounts = true;
        directories = [
            "/var/lib/nixos"
            "/var/lib/systemd"
        ]
        ++ lib.optional (getEnableOption [ "networking" "wireless" "iwd" ]) "/var/lib/iwd"
        ++ lib.optional (getEnableOption [ "virtualisation" "libvirtd" ]) "/var/lib/libvirt"
        ++ lib.optional (getEnableOption [ "services" "greetd" ]) { directory = "/var/cache/tuigreet"; user = "greeter"; group = "greeter"; }
        ++ lib.optional (getEnableOption [ "services" "syncthing" ]) (with config.services.syncthing; { directory = dataDir; inherit user group; })
        ;
        files = [
            "/etc/adjtime"
            "/etc/machine-id"
        ];
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

    system.stateVersion = "23.05";
}
