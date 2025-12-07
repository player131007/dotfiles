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
        };

        alias.l = "log --all --graph --pretty=graph";
        pretty.graph = "format:%C(brightcyan)%h  %C(white)%an  %C(yellow)%ad  %C(auto)%D%n%s%n";

        diff = {
          renames = "copies";
          interHunkContext = 10;
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
