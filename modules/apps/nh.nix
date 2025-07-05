{
  # needed for nh to know which specialisation we are on
  flake.modules.nixos.pc =
    { lib, ... }:
    {
      options.specialisation = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options.configuration = lib.mkOption {
                type = lib.types.submoduleWith {
                  modules = lib.singleton {
                    environment.etc."specialisation".text = name;
                  };
                };
              };
            }
          )
        );
      };
    };

  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.nh ];
    };
}
