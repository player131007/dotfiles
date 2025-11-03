{
  programs.bash.interactiveShellInit = /* bash */ ''
    bind '"\e[1;5D": shell-backward-word'
    bind '"\e[1;5C": shell-forward-word'
    bind '"\C-h": shell-backward-kill-word'
    bind '"\e[3;5~": shell-kill-word'

    bind '"\e[3;3~": kill-word'

    bind '"\ee": edit-and-execute-command'
  '';
}
