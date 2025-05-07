{
  pkgs,
  config,
  ...
}:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-unikey
    ];
  };

  xdg.configFile."fcitx5" = {
    enable = config.i18n.inputMethod.enable == true && config.i18n.inputMethod.type == "fcitx5";
    source = ./.;
  };
}
