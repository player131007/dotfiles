{ pkgs, ... }:
{
  imports = [
    ./btop
    ./firefox
    ./fish
    ./foot
    ./gtk
    ./fcitx5
    ./helix
    ./river
  ];

  programs = {
    bash.enable = true;
    nh.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        global = {
          hide_env_diff = true;
        };
      };
    };

    git = {
      enable = true;
      package = pkgs.git;
      userName = "Lương Việt Hoàng";
      userEmail = "tcm4095@gmail.com";
    };

    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      config = {
        gpu-api = "opengl";
        vo = "gpu-next";
        hwdec = "vaapi";

        deband-iterations = 2;
        deband-threshold = 35;
        deband-range = 20;
        deband-grain = 5;
      };
    };

    ringboard = {
      enable = true;
      wayland.enable = true;
    };
  };

  home.packages = with pkgs; [
    brightnessctl

    npins
    sttr
    jq
    calc
    ripgrep
    xdg-utils
    btop
    _7zz

    keepassxc
    looking-glass-client

    ringboard-cli
    ringboard-tui
  ];
}
