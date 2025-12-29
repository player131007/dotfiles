{ pkgs, ... }:
{
  my.hjem.packages = with pkgs; [
    npins
    jq
    calc
    ripgrep
    xdg-utils
    _7zz-rar
    keepassxc
  ];
}
