{ pkgs, ... }:
{
  fonts.enableDefaultPackages = false;

  fonts.fontconfig = {
    subpixel.rgba = "rgb";
    defaultFonts = {
      sansSerif = [ "Inter" ];
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "Iosevka Fixed" ];
    };
  };

  fonts.packages = with pkgs; [
    inter
    (iosevka-bin.override { variant = "SGr-IosevkaFixed"; })

    freefont_ttf
    gyre-fonts

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];
}
