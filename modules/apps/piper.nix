{
  flake.modules.nixos.pc = {
    services.ratbagd.enable = true;
  };

  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.piper ];
    };
}
