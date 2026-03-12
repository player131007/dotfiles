{
  pkgs,
  lib,
  config,
  ...
}:
{
  environment.systemPackages = [ pkgs.eza ];

  environment.sessionVariables = lib.mkIf config.documentation.man.enable {
    # less doesn't support coloring text formatted with ANSI escape sequences
    MANROFFOPT = "-P-c";
    MANPAGER = "less -Rs --use-color -Dd+y -Du+b";
  };

  programs = {
    bash.interactiveShellInit = /* bash */ ''
      bind '"\e[1;5D": shell-backward-word'
      bind '"\e[1;5C": shell-forward-word'
      bind '"\C-h": shell-backward-kill-word'
      bind '"\e[3;5~": shell-kill-word'

      bind '"\e[3;3~": kill-word'

      bind '"\ee": edit-and-execute-command'
    '';

    nano.enable = false;
  };
}
