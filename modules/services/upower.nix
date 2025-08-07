{
  flake.modules.nixos.pc =
    { config, ... }:
    {
      services.upower = {
        enable = true;
        criticalPowerAction = "PowerOff";
      };
      preservation.preserveAt.${config.stuff.persistDir}.directories = [ "/var/lib/upower" ];
    };
}
