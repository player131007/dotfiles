{
  pkgs,
  ...
}:
{
  i18n.inputMethod = {
    enable = false;
    type = "fcitx5";
    fcitx5 = {
      addons = [ pkgs.fcitx5-unikey ];
      waylandFrontend = true;
    };
  };
}
