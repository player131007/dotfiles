{ promise, types, ... }: {
  inputs = {
    mkWrapper.from = { parent }: parent.mkWrapper;
    nixpkgs.from = { parent }: parent.nixpkgs;
  };

  options = {
    package = {
      type = types.derivation;
      default = promise ({ inputs }: inputs.nixpkgs.pkgs.carapace);
    };
  };

  mutations."/bash".interactiveShellInit = promise (
    { inputs, result }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
    in
    /* bash */ ''
      eval "$(${getExe result} _carapace bash)"
    ''
  );

  inputs.mkWrapper.options = promise (
    { options }:
    {
      inherit (options) package;

      environment = {
        CARAPACE_ENV = "0";
        CARAPACE_LENIENT = "1";
        CARAPACE_EXCLUDES = "nix,git";
      };
    }
  );

  result = promise ({ results }: results.mkWrapper);
}
