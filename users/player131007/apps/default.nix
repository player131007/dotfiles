{
  pkgs,
  lib,
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
  };

  programs.git = {
    enable = true;
    package = pkgs.git;
    userName = "Lương Việt Hoàng";
    userEmail = "tcm4095@gmail.com";
    extraConfig = {
      core.autocrlf = "input";
      core.pager = "less -FRX";
    };
  };

  programs.mpv = {
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

  home.packages = with pkgs; [
    swaybg
    grim
    slurp
    foot
    brightnessctl

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
    clang

    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  home.sessionVariables = {
    ASAN_SYMBOLIZER_PATH = lib.getExe' pkgs.llvm "llvm-symbolizer";
  };
}
