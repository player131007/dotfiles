{ inputs, ... }:
{
  imports = [
    inputs.git-hooks-nix.flakeModule
  ];

  perSystem =
    { pkgs, ... }:
    {
      pre-commit.settings = {
        gitPackage = pkgs.git;
        hooks = {
          nixfmt-rfc-style = {
            enable = true;
            files = ".*\\.nix";
            excludes = [
              "npins\\/default\\.nix"
            ];
          };
        };
      };
    };
}
