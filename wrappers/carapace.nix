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
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
      finalWrapper = options { };
    in
    /* bash */ ''
      eval "$(${getExe finalWrapper} _carapace bash)"
    ''
  );

  result = promise (
    { options, inputs }:
    inputs.mkWrapper {
      inherit (options) package;

      environment = {
        CARAPACE_ENV = "0";
        CARAPACE_LENIENT = "1";
        CARAPACE_EXCLUDES = "nix,git";
      };
    }
  );
}
