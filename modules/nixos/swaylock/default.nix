{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.modules.swaylock;
in
{
    options.modules.swaylock = {
        enable = mkEnableOption "swaylock";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = [ pkgs.swaylock ];
        security.pam.services.swaylock = {};
    };
}
