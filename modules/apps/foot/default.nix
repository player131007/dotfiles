{
  flake.modules.nixos.pc =
    { pkgs, ... }:
    {
      fonts.packages = [ pkgs.nerd-fonts.iosevka-term ];
      programs.oh-my-posh.settings.pwd = "osc7";
    };

  flake.modules.maid.pc = {
    systemd.tmpfiles.rules = [
      "f %h/.config/foot/colors.ini - - - -"
    ];
    programs.wallust.settings.templates.foot = {
      template = ./colors.ini;
      target = "~/.config/foot/colors.ini";
    };
    programs.foot = {
      enable = true;
      settings = {
        main = {
          include = [ "~/.config/foot/colors.ini" ];
          shell = "fish";
          pad = "5x5 center";
          font = "IosevkaTerm NF:size=11";
        };
        cursor.blink = "yes";
        colors.alpha = 0.9;
      };
    };
  };
}
