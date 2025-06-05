{
  pkgs,
  modulesPath,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # the nixpkgs flake is pinned by default
  system.installer.channel.enable = false;

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

  environment.systemPackages = [ pkgs.cryptsetup ];

  services = {
    lvm.enable = true;
    resolved = {
      enable = true;
      fallbackDns = [ ];
    };
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # doesn't work, see funny pr here
  # https://github.com/NixOS/nixpkgs/pull/291750
  # boot.initrd.systemd.enable = true;
  # no zfs
  boot.supportedFilesystems.zfs = lib.mkForce false;

  isoImage.squashfsCompression = "zstd -Xcompression-level 10";
}
