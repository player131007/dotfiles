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

    networks = {
      "50-school" = {
        matchConfig = {
          WLANInterfaceType = "station";
          SSID = [ "Hust.*" ];
        };
        networkConfig = {
          DNSOverTLS = "opportunistic";
          Domains = [ "~hust.edu.vn." ];
          IPv6PrivacyExtensions = "kernel";
        };

        DHCP = "yes";
        dhcpV4Config = {
          UseDNS = true;
          RouteMetric = 1025;
        };
        ipv6AcceptRAConfig = {
          UseDNS = true;
          RouteMetric = 1025;
        };
      };

      "99-ethernet-default-dhcp" = {
        dhcpV4Config.UseDNS = false;
        dhcpV6Config.UseDNS = false;
        ipv6AcceptRAConfig.UseDNS = false;
      };

      "99-wireless-client-dhcp" = {
        dhcpV4Config.UseDNS = false;
        dhcpV6Config.UseDNS = false;
        ipv6AcceptRAConfig.UseDNS = false;
      };
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "1.1.1.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
        "9.9.9.9#dns.quad9.net"
        "2620:fe::9#dns.quad9.net"
        "8.8.8.8#dns.google"
        "2001:4860:4860::8888#dns.google"
      ];
      DNSOverTLS = true;
    };
  };
}
