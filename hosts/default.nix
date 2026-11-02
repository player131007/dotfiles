let
  inherit (builtins) mapAttrs;

  sources = import ../npins;
  modules = import ../modules;

  mkHost =
    nixpkgs: hostname: args:
    import "${nixpkgs}/nixos/lib/eval-config.nix" (
      args
      // {
        system = null;
        modules = args.modules or [ ] ++ [
          modules.base
          ({ lib, ... }: {
            imports =
              ./${hostname}
              |> lib.fileset.fileFilter (file: file.hasExt "nix" && !lib.strings.hasPrefix "_" file.name)
              |> lib.fileset.toList;
            networking.hostName = hostname;
          })
        ];
      }
    );
in
mapAttrs (mkHost sources.nixpkgs) {
  tahari = { };

  unora = {
    modules = [
      { system.stateVersion = "26.11"; }
      modules.persistence
      (import sources.hjem { }).nixosModules.hjem
    ];
  };
}
