let
  sources = import ./npins;

  myLib = import ./lib.nix {
    lib = import "${sources.nixpkgs}/lib";
  };

  mkHost =
    nixpkgs: hostname: args:
    let
      myLib = import ./lib.nix {
        lib = import "${nixpkgs}/lib";
      };

      defaultModule =
        { lib, pkgs, ... }:
        {
          networking.hostName = lib.mkDefault hostname;
          _module.args.myPkgs = import ./packages.nix { inherit pkgs; };
        };
    in
    import "${nixpkgs}/nixos/lib/eval-config.nix" (
      args
      // {
        modules =
          args.modules or [ ]
          ++ myLib.listModulesRecursive [
            ./modules/base
            ./hosts/${hostname}

            defaultModule
          ];

        specialArgs = args.specialArgs or { } // {
          inherit myLib sources;
        };

        system = null;
      }
    );
in
builtins.mapAttrs (mkHost sources.nixpkgs) {
  tahari = {
    modules = [ ./modules/iso-image.nix ];
  };

  unora = {
    modules = myLib.listModulesRecursive [
      ./modules/pc
      ./modules/libvirtd.nix
      ./modules/programs
      { system.stateVersion = "26.11"; }
      ({ pkgs, ... }: {
        _module.args.wrappers = import ./wrappers.nix { inherit pkgs; };
      })
    ];
  };
}
