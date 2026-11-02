{
  pkgs,
  wrappers,
  ...
}:
{
  fonts.packages = [
    pkgs.nerd-fonts.iosevka-term
  ];

  my.user.packages = [ wrappers.foot ];
}
