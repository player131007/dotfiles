{
  programs.fish = {
    enable = true;
    useBabelfish = true;
    interactiveShellInit = /* fish */ ''
      set -g fish_greeting

      function last_history_item
        echo $history[1]
      end
      abbr -a !! --position anywhere --function last_history_item

      function fish_user_key_bindings
        bind ctrl-left backward-token
        bind ctrl-right forward-token
        bind ctrl-backspace backward-kill-token
      end
    '';
  };
}
