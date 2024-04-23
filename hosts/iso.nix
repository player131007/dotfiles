{ pkgs, config, modulesPath, lib, ... }: {
    imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ];

    nixpkgs.hostPlatform = "x86_64-linux";

    # the nixpkgs flake is pinned by default
    system.installer.channel.enable = false;
    nix.channel.enable = false;

    # disabling channels unsets nix-path in nix.conf, we have to set it here
    nix.settings.nix-path = config.nix.nixPath;

    networking.wireless.enable = false;
    networking.useDHCP = false;
    networking.dhcpcd.enable = false;

    systemd.network.wait-online.enable = false;
    systemd.network = {
        enable = true;
        networks = {
            wired = {
                matchConfig.Type = "ether";
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

    networking.wireless.iwd.enable = true;
    networking.nameservers = [
        "1.1.1.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
    ];
    services.resolved = {
        enable = true;
        fallbackDns = [
            "9.9.9.9#dns.quad9.net"
            "8.8.8.8#dns.google"
            "2620:fe::9#dns.quad9.net"
            "2001:4860:4860::8888#dns.google"
        ];
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config = {
        allowUnfree = true;
        packageOverrides = prev: {
            gitMinimal = prev.gitMinimal.override {
                withManual = true;
                doInstallCheck = false;
            };
            _7zz = prev._7zz.override { enableUnfree = true; };
        };
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

    # no zfs
    boot.supportedFilesystems.zfs = lib.mkForce false;

    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager
    ];

    isoImage.squashfsCompression = "zstd -Xcompression-level 10";
}
