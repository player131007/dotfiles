{
  systemd.network.networks = {
    "50-school" = {
      matchConfig = {
        WLANInterfaceType = "station";
        SSID = [ "Hust_*_Giangduong" ];
      };
      networkConfig = {
        DHCP = "yes";
        DNSOverTLS = false;
        Domains = [ "~hust.edu.vn." ];
        IPv6PrivacyExtensions = "kernel";
      };
      dhcpV4Config.RouteMetric = 1025;
      ipv6AcceptRAConfig.RouteMetric = 1025;
    };
  };
}
