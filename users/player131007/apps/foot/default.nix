{
  pkgs,
  config,
  npins,
  ...
}:
{
  home.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.meslo-lg
  ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        include = toString (
          config.colorscheme {
            template = "${npins.tinted-terminal}/templates/foot-base24.mustache";
            extension = "ini";
          }
        );
        font = "Meslo LG S:pixelsize=14,Symbols Nerd Font Mono:pixelsize=10";
        shell = "fish";
        pad = "5x5 center";
      };
      cursor.blink = "yes";
      colors.alpha = 0.9;
    };
  };
}
