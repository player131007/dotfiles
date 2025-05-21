{
  pkgs,
  config,
  npins,
  ...
}:
{
  home.packages = [ pkgs.nerd-fonts.iosevka-term ];

  # oh-my-posh takes care of shell integration
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
        font = "IosevkaTerm NF:size=12";
        shell = "fish";
        pad = "5x5 center";
      };
      cursor.blink = "yes";
      colors.alpha = 0.9;
    };
  };
}
