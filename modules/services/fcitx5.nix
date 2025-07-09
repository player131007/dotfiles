{
  # FIXME: make this user-specific
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          waylandFrontend = true;
          addons = [
            pkgs.fcitx5-bamboo
          ];
        };
      };
    };
}
