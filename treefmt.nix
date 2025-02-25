{inputs, ...}: {
  imports = [inputs.treefmt-nix.flakeModule];

  perSystem = {
    treefmt = {
      programs.alejandra = {
        enable = true;
        excludes = ["npins/*"];
      };
    };
  };
}
