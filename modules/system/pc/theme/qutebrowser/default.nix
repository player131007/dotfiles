{ lib, ... }:
{
  my.hjem = {
    xdg.config.files."qutebrowser/config.py" = {
      enable = lib.mkDefault false;
      text = lib.mkAfter (builtins.readFile ./colors.py);
    };
  };
}
