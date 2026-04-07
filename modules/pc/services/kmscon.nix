{ lib, pkgs, ... }:
{
  services.kmscon = {
    hwRender = true;
    fonts = lib.singleton {
      name = "IosevkaTerm Nerd Font";
      package = pkgs.nerd-fonts.iosevka-term;
    };
  };
}
