{
  pkgs,
  ...
}: {
  imports = [
    ./btop
    ./firefox
    ./fish
    ./foot
    ./gtk
    ./fcitx5
    ./helix
    ./yambar
  ];

  programs = {
    bash.enable = true;
    nh.enable = true;

    git = {
      enable = true;
      package = pkgs.git;
      userName = "Lương Việt Hoàng";
      userEmail = "tcm4095@gmail.com";
    };

    mpv = {
      enable = true;
      defaultProfiles = ["gpu-hq"];
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
  };

  services.clipse = {
    enable = true;
    # i'll do it myself
    package = null;
    imageDisplay = {
      type = "sixel";
      scaleX = 14;
      scaleY = 14;
      heightCut = 10;
    };
  };

  home.packages = with pkgs; [
    swaybg
    grim
    slurp
    foot
    brightnessctl

    clipse
    npins
    sttr
    jq
    calc
    wl-clipboard
    ripgrep
    xdg-utils
    btop
    _7zz
    wl-screenrec

    keepassxc
    looking-glass-client
  ];
}
