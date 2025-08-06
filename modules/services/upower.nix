{
  flake.modules.nixos.pc =
    { config, ... }:
    {
      services.upower.enable = true;
      preservation.preserveAt.${config.stuff.persistDir}.directories = [ "/var/lib/upower" ];
    };
}
