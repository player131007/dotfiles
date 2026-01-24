{ config, lib, ... }:
{
  networking = {
    wireless = {
      enable = false;
      iwd.enable = true;
    };

    useNetworkd = true;
    dhcpcd.enable = !config.networking.useNetworkd;
    networkmanager.enable = lib.mkForce (!config.networking.useNetworkd);
    nftables.enable = true;
  };

  systemd.network = {
    enable = config.networking.useNetworkd;
    wait-online.enable = false;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      Domains = [ "~." ];
      DNSOverTLS = true;
    };
  };

  networking.nameservers = [
    "1.1.1.1#cloudflare-dns.com"
    "2606:4700:4700::1111#cloudflare-dns.com"
    "9.9.9.9#dns.quad9.net"
    "2620:fe::9#dns.quad9.net"
    "8.8.8.8#dns.google"
    "2001:4860:4860::8888#dns.google"
  ];
}
