{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      fonts.packages = [ pkgs.nerd-fonts.iosevka-term ];
      programs.oh-my-posh.settings.pwd = "osc7";
    };

  flake.modules.maid.pc = {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          shell = "fish";
          pad = "5x5 center";
          font = "IosevkaTerm NF";
        };
        cursor.blink = "yes";
        colors.alpha = 0.9;
      };
    };
  };
}
