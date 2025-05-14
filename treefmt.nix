{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      settings.global.excludes = [
        "npins/default.nix"
        "npins/sources.json"
      ];
      programs.nixfmt.enable = true;
    };
  };
}
