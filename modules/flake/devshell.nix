{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells = {
        default = pkgs.mkShellNoCC {
          nativeBuildInputs = config.pre-commit.settings.enabledPackages ++ [
            config.pre-commit.settings.package
            pkgs.nixd
          ];
          shellHook = config.pre-commit.installationScript;
        };

        neovim = pkgs.mkShellNoCC {
          packages = [
            config.legacyPackages.neovim.devMode
            pkgs.npins
          ];
        };
      };
    };
}
