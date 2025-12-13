let
  sources = import ./npins;
  myLib = import ./lib {
    lib = import "${sources.nixpkgs}/lib";
  };

  mkHost =
    hostname: args:
    import "${sources.nixpkgs}/nixos/lib/eval-config.nix" (
      args
      // {
        modules =
          args.modules or [ ]
          ++ myLib.recursivelyImport [
            ./modules/system/base
            ./modules/programs/base

            ./modules/hosts/${hostname}
            (
              { lib, pkgs, ... }:
              {
                networking.hostName = lib.mkDefault hostname;
                _module.args.myPkgs = import ./packages.nix { inherit pkgs; };
              }
            )
          ];

        specialArgs = args.specialArgs or { } // {
          inherit myLib sources;
        };

        system = null;
      }
    );
in
builtins.mapAttrs mkHost {
  tahari = {
    modules = myLib.recursivelyImport [
      ./modules/system/iso
    ];
  };

  unora = {
    modules = myLib.recursivelyImport [
      ./modules/programs/extras
      ./modules/system/pc
      { system.stateVersion = "23.05"; }
    ];

    specialArgs = {
      username = "player131007";
    };
  };
}
