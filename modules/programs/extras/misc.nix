{ pkgs, ... }:
{
  my.hjem.packages = with pkgs; [
    npins
    jq
    calc
    brightnessctl
    ripgrep
    xdg-utils
    _7zz-rar
    keepassxc
  ];
}
