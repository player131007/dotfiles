{
  inputs,
  self,
  ...
}: let
  inherit (inputs.home-manager) lib;
in {
  flake.homeConfigurations."player131007@laptop" = lib.homeManagerConfiguration {
    pkgs = self.nixosConfigurations.laptop.pkgs;
    modules = [
      ./player131007
      inputs.base16.homeManagerModule
    ];
  };
}
