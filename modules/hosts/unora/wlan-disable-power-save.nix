{
  flake.modules.nixos."nixosConfigurations/unora" =
    { pkgs, lib, ... }:
    {
      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*" RUN+="${lib.getExe pkgs.iw} dev %k set power_save off"
      '';
    };
}
