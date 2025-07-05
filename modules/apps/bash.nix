{
  flake.modules.nixos.base = {
    programs.bash.interactiveShellInit = # bash
      ''
        bind '"\e[1;5D": shell-backward-word'
        bind '"\e[1;5C": shell-forward-word'
        bind '"\C-h": shell-backward-kill-word'
      '';
  };
}
