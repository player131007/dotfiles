_adios: {
  options = {
    configFile.default = ./config.toml;
    wrapperAttrs.mutators = [ "/git" ];
  };

  # starship looks up PATH for the starship executable

  mutations."/bash".interactiveShellInit =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
      finalWrapper = options { };
    in
    /* bash */ ''
      eval "$(PATH=${finalWrapper}/bin ${getExe finalWrapper} init bash --print-full-init)"
    '';

  mutations."/fish".interactiveShellInit =
    { options, inputs }:
    let
      finalWrapper = options { };
      inherit (inputs.nixpkgs.lib) getExe;
    in
    /* fish */ ''
      PATH=${finalWrapper}/bin ${getExe finalWrapper} init fish --print-full-init | source
    '';

  mutations."/nushell".sourceFiles =
    { options, inputs }:
    let
      inherit (inputs.nixpkgs.lib) getExe;
      finalWrapper = options { };

      starship-nu = inputs.nixpkgs.pkgs.runCommand "starship.nu" { } ''
        PATH=${finalWrapper}/bin ${getExe finalWrapper} init nu > $out
      '';
    in
    [ starship-nu ];
}
