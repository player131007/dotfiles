{ myPkgs, ... }:
{
  my.hjem = {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = [ myPkgs.neovim ];
  };
}
