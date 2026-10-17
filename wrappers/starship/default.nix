{ promise, ... }: {
  options = {
    configFile.default = ./config.toml;
    wrapperAttrs.mutators = [ "/git" ];
  };

  # starship looks up PATH for the starship executable

  mutations."/bash".interactiveShellInit = promise (
    { inputs, result }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
    in
    /* bash */ ''
      eval "$(PATH=${result}/bin ${getExe result} init bash --print-full-init)"
    ''
  );

  mutations."/fish".interactiveShellInit = promise (
    { inputs, result }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
    in
    /* fish */ ''
      PATH=${result}/bin ${getExe result} init fish --print-full-init | source
    ''
  );
}
