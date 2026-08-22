_adios: {
  options = {
    shellInit.mutators = [
      "/nix-index"
      "/carapace"
      "/direnv"
      "/nushell"
    ];
    sourceFiles.mutators = [ "/starship" ];
  };

  mutations."/nushell".shellInit =
    { }:
    /* nu */ ''
      use ${./modules}/psub.nu
    ''
    + builtins.readFile ./config.nu;
}
