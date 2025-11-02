{ pkgs, ... }:
{
  console.useXkbConfig = true;

  services.keyd = {
    enable = true;
    keyboards.all = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        pkgs.qt6Packages.fcitx5-unikey
      ];
    };
  };
}
