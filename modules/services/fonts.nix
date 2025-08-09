{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      fonts.fontconfig = {
        subpixel.rgba = "rgb";
        defaultFonts =
          let
            emoji = [ "Noto Color Emoji" ];
            cjk-order = [
              "KR"
              "JP"
              "SC"
              "TC"
              "HK"
            ];
            cjk = type: map (lang: "Noto ${type} CJK ${lang}") cjk-order;
          in
          {
            serif = [ "Noto Serif" ] ++ (cjk "Serif") ++ emoji;
            sansSerif = [
              "Inter"
              "Noto Sans"
            ]
            ++ (cjk "Sans")
            ++ emoji;
            monospace = [ "Noto Sans Mono" ] ++ (cjk "Sans Mono") ++ emoji;
            inherit emoji;
          };
      };
      fonts.enableDefaultPackages = false;
      fonts.packages = with pkgs; [
        noto-fonts-color-emoji
        noto-fonts-lgc-plus
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        inter
        iosevka
      ];
    };
}
