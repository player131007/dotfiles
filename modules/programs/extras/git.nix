{ lib, pkgs, ... }:
{
  my.hjem = {
    packages = [ pkgs.git ];
    xdg.config.files."git/config" = {
      generator = lib.generators.toGitINI;
      value = {
        user = {
          name = "Lương Việt Hoàng";
          email = "tcm4095@gmail.com";
        };

        core = {
          autocrlf = "input";
          compression = 9;
          pager = "${lib.getExe pkgs.diff-so-fancy} | less";
        };

        alias.l = "log --all --graph --pretty=graph";
        pretty.graph = "format:%C(brightcyan)%h  %C(white)%an  %C(yellow)%ad  %C(auto)%D%n%s%n";

        diff = {
          renames = "copies";
          interHunkContext = 10;
        };

        color = {
          diff-highlight = {
            oldNormal = "red bold";
            newNormal = "green bold";
            oldHighlight = "red bold #4d242f";
            newHighlight = "green bold #2a383b";
          };

          diff = {
            meta = "yellow dim";
            frag = "magenta bold";
            func = "brightwhite dim";
            commit = "yellow bold";
            old = "red bold";
            new = "green bold";
            whitespace = "magenta reverse dim";
          };
        };

        log = {
          date = "relative";
          graphColors = "blue,yellow,cyan,magenta,green,red";
        };

        url = {
          "https://github.com/player131007/".insteadOf = [ "me:" ];
          "https://github.com/".insteadOf = [ "gh:" ];
          "git@github.com:".pushInsteadOf = [
            "https://github.com/"
            "gh:"
          ];
          "git@github.com:player131007/".pushInsteadOf = [
            "https://github.com/player131007/"
            "me:"
          ];
        };

        uploadpack.allowFilter = true;

        interactive = {
          singlekey = true;
          diffFilter = "${lib.getExe pkgs.diff-so-fancy} --patch";
        };
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
