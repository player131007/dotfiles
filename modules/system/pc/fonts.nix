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
  };

  fonts.enableDefaultPackages = false;
  fonts.packages = with pkgs; [
    inter
    iosevka
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];
}
