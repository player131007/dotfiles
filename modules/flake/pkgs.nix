{ fromRoot, moduleWithSystem, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      inputs',
      ...
    }:
    {
      legacyPackages =
        let
          rust-toolchain = inputs'.fenix.packages.minimal.toolchain;

          scope-with-overrides = lib.makeScope pkgs.newScope (self: {
            rustPlatform_nightly = self.callPackage (
              { makeRustPlatform }:
              makeRustPlatform {
                rustc = rust-toolchain;
                cargo = rust-toolchain;
              }
            ) { };
          });
        in
        lib.packagesFromDirectoryRecursive {
          inherit (scope-with-overrides) callPackage newScope;
          directory = fromRoot "pkgs";
        };
    };

  flake.modules.generic.otherpkgs = moduleWithSystem (
    { config }:
    {
      _module.args.otherpkgs = config.legacyPackages;
    }
  );
}
