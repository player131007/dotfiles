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
          deadnix = {
            enable = true;
            before = [ "nixfmt-rfc-style" ];
            settings = {
              edit = true;
            };
            files = ".*\\.nix";
          };
          nixfmt-rfc-style = {
            enable = true;
            files = ".*\\.nix";
          };
        };
      };
    };
}
