{ config, lib, ... }:
{
  config = lib.mkIf config.networking.wireless.iwd.enable {
    persist.at.persistdir.directories = lib.singleton {
      directory = "/var/lib/iwd";
      mode = "0700";
    };
  };
}
