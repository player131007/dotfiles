{ pkgs, config, modulesPath, lib, ... }: {
    imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.hostPlatform = "x86_64-linux";

    # the nixpkgs flake is pinned by default
    system.installer.channel.enable = false;
    nix.channel.enable = false;

    # disabling channels unsets nix-path in nix.conf, we have to set it here
    nix.settings.nix-path = config.nix.nixPath;

    networking = {
        wireless.enable = false;
        wireless.iwd.enable = true;
        useNetworkd = true;
        dhcpcd.enable = false;
        nameservers = [
            "1.1.1.1#cloudflare-dns.com"
            "2606:4700:4700::1111#cloudflare-dns.com"
            "9.9.9.9#dns.quad9.net"
            "8.8.8.8#dns.google"
            "2620:fe::9#dns.quad9.net"
            "2001:4860:4860::8888#dns.google"
        ];
    };

    services.resolved = {
        enable = true;
        fallbackDns = [];
    };

    systemd.network = {
        enable = true;
        wait-online.enable = false;
    };

    boot.kernelPackages = pkgs.linuxPackages_zen;

    boot.initrd.systemd.enable = true;
    # no zfs
    boot.supportedFilesystems.zfs = lib.mkForce false;

    environment.systemPackages = with pkgs; [
        gitMinimal
        home-manager
    ];

    isoImage.squashfsCompression = "zstd -Xcompression-level 10";
}
