{
  flake.modules.nixos.base = {
    security.sudo = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture=never
      '';
    };
  };

  flake.modules.nixos.pc = {
    users.users.player131007.extraGroups = [ "wheel" ];
  };
}
