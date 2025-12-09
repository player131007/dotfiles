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
              {
                lib,
                pkgs,
                config,
                ...
              }:
              {
                networking.hostName = lib.mkDefault hostname;
                _module.args.myPkgs = import ./packages.nix { inherit pkgs; };

                nix = {
                  registry.nixpkgs.to = {
                    type = "path";
                    path = sources.nixpkgs.outPath;
                  };
                  nixPath = [
                    "nixpkgs=${sources.nixpkgs.outPath}"
                  ];
                };
                system.nixos = {
                  versionSuffix =
                    let
                      inherit (config.system.nixos) revision;
                    in
                    if revision == "dirty" then ".dirty" else ".${builtins.substring 0 8 revision}";
                  revision = sources.nixpkgs.revision or "dirty";
                };
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
      ./modules/programs
      ./modules/system/pc
      { system.stateVersion = "23.05"; }
    ];

    specialArgs = {
      username = "player131007";
    };
  };
}
