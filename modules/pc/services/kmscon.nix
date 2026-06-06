{ pkgs, ... }:
{
  fonts.packages = [ pkgs.nerd-fonts.iosevka-term ];

  services.kmscon.config = {
    hwaccel = true;
    font-name = "IosevkaTerm Nerd Font";
  };
}
