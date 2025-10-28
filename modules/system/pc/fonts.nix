{ pkgs, ... }:
{
  fonts.fontconfig = {
    subpixel.rgba = "rgb";
    defaultFonts = {
      sansSerif = [ "Inter" ];
    };
  };
  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    inter
  ];
}
