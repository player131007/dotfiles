{
  flake.modules.nixos."nixosConfigurations/unora" =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.diff-so-fancy ];
    };
}
