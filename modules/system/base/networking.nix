{ config, ... }:
{
  networking = {
    wireless = {
      enable = false;
      iwd.enable = true;
    };

    useNetworkd = true;
    dhcpcd.enable = !config.networking.useNetworkd;
  };

  systemd.network = {
    enable = true;
    wait-online.enable = false;
  };
}
