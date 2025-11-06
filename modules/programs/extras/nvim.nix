{
  inputs,
  pkgs,
  ...
}:
{
  my.hjem = {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = [ inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.neovim ];
  };
}
