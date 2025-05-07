{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      settings.global.excludes = [ "npins/*" ];
      programs.nixfmt.enable = true;
    };
  };
}
