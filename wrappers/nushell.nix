_adios: {
  options = {
    shellInit.mutators = [
      "/nix-index"
      "/carapace"
      "/direnv"
    ];
    sourceFiles.mutators = [ "/starship" ];
  };
}
