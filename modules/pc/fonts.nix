{ pkgs, ... }:
{
  fonts.fontconfig = {
    subpixel.rgba = "rgb";
    defaultFonts =
      let
        cjk =
          font:
          map (lang: "${font} ${lang}") [
            "JP"
            "KR"
            "SC"
            "TC"
            "HK"
          ];
      in
      {
        serif = cjk "Noto Serif CJK";
        sansSerif = [ "Inter" ] ++ cjk "Noto Sans CJK";
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
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];
}
