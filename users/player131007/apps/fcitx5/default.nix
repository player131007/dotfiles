{
  pkgs,
  config,
  ...
}:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [ pkgs.fcitx5-unikey ];
      waylandFrontend = true;
    };
  };
}
