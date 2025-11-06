{ lib, pkgs, ... }:
{
  # FIXME: make this user-specific
  environment.shellAliases = {
    gs = "git status --short";
    ga = "git add";
    gaa = "git add -A";
    gc = "git commit";
    gd = "git diff";
    gp = "git push";
    gl = "git log --all --graph --pretty=format:'%C(brightcyan)%h  %C(white)%an  %C(yellow)%ad %C(auto)%D%n%s%n'";
  };

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
