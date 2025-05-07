{
  pkgs,
  config,
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
          config.scheme {
            template = ./foot.mustache;
            extension = ".ini";
          }
        );
        font = "Meslo LG S:pixelsize=14,Symbols Nerd Font Mono:pixelsize=10";
        shell = "fish";
        pad = "5x5 center";
      };
      cursor.blink = "yes";
      colors.alpha = 0.7;
    };
  };

  # oh-my-posh will take care of shell integration
}
