{
  flake.modules.nixos."nixosConfigurations/tahari" =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.cryptsetup
        pkgs.git
      ];
    };
}
