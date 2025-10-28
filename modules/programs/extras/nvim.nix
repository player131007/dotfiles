{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  hjem.extraModules = lib.singleton {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = [ inputs.self.legacyPackages.${pkgs.stdenv.hostPlatform.system}.neovim ];
  };
}
