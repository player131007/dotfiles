{
  lib,
  promise,
  types,
  ...
}:
{
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    interactiveShellInit = {
      type = types.string;
      mutators = [
        "/nix-index"
        "/starship"
        "/carapace"
        "/direnv"
      ];
      mergeFunc = lib.merge.strings.concatLines;
    };

    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.bash);
    };
  };

  result = promise (
    { options, inputs }:
    let
      inherit (inputs.nixpkgs) pkgs lib;
      rcfile =
        if options ? interactiveShellInit then
          pkgs.writeText "bashrc" options.interactiveShellInit
        else
          null;
    in
    inputs.mkWrapper {
      inherit (options) package;

      symlinks = {
        "$out/bashrc" = rcfile;
      };

      flags = lib.optionals (rcfile != null) [
        "--rcfile"
        "$out/bashrc"
      ];
    }
  );
}
