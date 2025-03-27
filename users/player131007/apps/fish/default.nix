{
  pkgs,
  config,
  ...
}: {
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "puffer";
        src = pkgs.fetchFromGitHub {
          owner = "nickeb96";
          repo = "puffer-fish";
          rev = "5d3cb25e0d63356c3342fb3101810799bb651b64";
          hash = "sha256-aPxEHSXfiJJXosIm7b3Pd+yFnyz43W3GXyUB5BFAF54=";
        };
      }
    ];
    interactiveShellInit = ''
      set -g fish_greeting
      source ${
        config.scheme {
          template = ./fish.mustache;
          extension = ".fish";
        }
      }
      function fish_user_key_bindings
        bind ctrl-c 'commandline ""'
        bind ctrl-left backward-token
        bind ctrl-right forward-token
        bind ctrl-backspace backward-kill-token
      end
    '';
  };
}
