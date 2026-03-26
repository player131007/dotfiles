{ pkgs, ... }:
{
  fonts.enableDefaultPackages = false;

  fonts.fontconfig = {
    subpixel.rgba = "rgb";
    defaultFonts = {
      sansSerif = [ "Inter" ];
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "Iosevka" ];
    };

    localConf = /* xml */ ''
      <?xml version='1.0'?>
      <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
      <fontconfig>
        <match>
          <test name="family" compare="eq">
            <string>Iosevka</string>
          </test>
          <edit name="fontfeatures" mode="append">
            <string>calt off</string>
          </edit>
        </match>
      </fontconfig>
    '';
  };

  fonts.packages = with pkgs; [
    inter
    iosevka

    freefont_ttf
    gyre-fonts
    unifont
    noto-fonts-color-emoji
  ];
}
