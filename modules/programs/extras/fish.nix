{ lib, ... }:
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
        bind alt-left backward-word
        bind alt-right forward-word
        bind alt-backspace backward-kill-word
        bind alt-delete kill-word

        bind ctrl-left backward-token
        bind ctrl-right forward-token
        bind ctrl-backspace backward-kill-token
        bind ctrl-delete kill-token
      end
    '';
  };

  my.hjem = {
    xdg.config.files."foot/foot.ini" = {
      enable = lib.mkDefault false;
      value.main.shell = "fish";
    };
  };
}
