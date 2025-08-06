{
  flake.modules.nixos.base = {
    networking.wireless = {
      enable = false;
      iwd.enable = true;
    };
  };

  flake.modules.nixos.pc =
    { config, lib, ... }:
    {
      preservation.preserveAt.${config.stuff.persistDir}.directories = lib.singleton {
        directory = "/var/lib/iwd";
        mode = "0700";
      };
    };
}
