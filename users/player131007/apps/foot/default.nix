{
  config,
  npins,
  ...
}:
{
  # oh-my-posh takes care of shell integration
  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "IosevkaTerm NF:size=12";
        shell = "fish";
        pad = "5x5 center";
      };
      cursor.blink = "yes";
      colors.alpha = 0.9;
    };
  };
}
