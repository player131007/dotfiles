{
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = config.pre-commit.settings.enabledPackages ++ [
          config.pre-commit.settings.package
          pkgs.nixd
        ];
        shellHook = config.pre-commit.installationScript;
      };
    };
}
