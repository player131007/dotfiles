{ pkgs, ... }:
{
  my.hjem.packages = with pkgs; [
    jq
    calc
    brightnessctl
    ripgrep
    xdg-utils
    _7zz-rar
    keepassxc
  ];
}
