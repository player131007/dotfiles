{
  pkgs,
  config,
  npins,
  ...
}:
{
  home.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.meslo-lg
  ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        include =
          let
            src = npins.tinted-terminal;
            tinted-terminal = pkgs.fetchFromGitHub {
              inherit (src.repository) owner repo;
              rev = src.revision;
              sha256 = src.hash;
            };
          in
          toString (
            config.colorscheme {
              template = "${tinted-terminal}/templates/foot-base24.mustache";
              extension = "ini";
            }
          );
        font = "Meslo LG S:pixelsize=14,Symbols Nerd Font Mono:pixelsize=10";
        shell = "fish";
        pad = "5x5 center";
      };
      cursor.blink = "yes";
      colors.alpha = 0.7;
    };
  };

  # oh-my-posh will take care of shell integration
}
