{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {
        nvim = pkgs.mkShellNoCC {
          packages = [
            config.legacyPackages.neovim.devMode
            pkgs.npins
          ];
        };
      };
    };
}
