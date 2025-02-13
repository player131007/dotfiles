{ pkgs, config, ... }:
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-unikey
    ];
  };

  xdg.configFile."fcitx5" = {
    enable = config.i18n.inputMethod.enabled == "fcitx5";
    source = ./.;
  };
}
