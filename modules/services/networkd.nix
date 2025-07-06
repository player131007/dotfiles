{
  flake.modules.nixos.base = {
    networking.useNetworkd = true;
    networking.dhcpcd.enable = false;
    systemd.network = {
      enable = true;
      wait-online.enable = false;
    };
  };
}
