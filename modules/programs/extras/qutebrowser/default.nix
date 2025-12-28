{ pkgs, ... }:
{
  fonts.packages = [
    pkgs.inter
    pkgs.iosevka
  ];

  my.hjem = {
    packages = [ pkgs.qutebrowser ];
    xdg.config.files."qutebrowser/config.py" = {
      enable = true;
      type = "copy";
      permissions = "600";
      clobber = true;
      text = builtins.readFile ./config.py;
    };
  };
}
