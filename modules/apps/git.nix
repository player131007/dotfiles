{
  flake.modules.nixos.pc = {
    # ideally this should only be user specific
    # but im too lazy to make a bash/fish module
    environment.shellAliases = {
      gs = "git status --short";
      ga = "git add";
      gaa = "git add -A";
      gc = "git commit";
      gd = "git diff";
      gp = "git push";
      gl = "git log --all --graph --pretty=format:'%C(brightcyan)%h  %C(white)%an  %C(yellow)%ad %C(auto)%D%n%s%n'";
    };
  };

  flake.modules.maid.pc =
    { lib, pkgs, ... }:
    {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "Lương Việt Hoàng";
            email = "tcm4095@gmail.com";
          };

          core = {
            autocrlf = "input";
            pager = "${lib.getExe pkgs.diff-so-fancy} | less -+X -FR --use-color";

            compression = 9;
          };

          color = {
            diff-highlight = {
              oldNormal = "red bold";
              oldHighlight = "red bold reverse";
              newNormal = "green bold";
              newHighlight = "green bold reverse";
            };

            diff = {
              meta = "white";
              frag = "magenta bold";
              whitespace = "17 reverse";
              commit = "yellow";
              old = "red bold";
              new = "green bold";
            };
          };

          diff = {
            renames = "copies";
            interHunkContext = 10;
          };

          log = {
            date = "relative";
            graphColors = "blue,yellow,cyan,magenta,green,red";
          };

          url = {
            "git@github.com:player131007/".insteadOf = [ "me:" ];
            "https://github.com/".insteadOf = [
              "gh:"
              "github:"
            ];
            "git@github.com:".pushInsteadOf = [ "https://github.com/" ];
          };

          interactive = {
            diffFilter = "${lib.getExe pkgs.diff-so-fancy} --patch";
            singlekey = true;
          };
          diff-so-fancy.markEmptyLines = false;
          status = {
            branch = true;
            showStash = true;
          };
          commit.verbose = true;
          merge.conflictStyle = "zdiff3";
        };
      };
    };
}
