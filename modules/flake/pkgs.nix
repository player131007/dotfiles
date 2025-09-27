{
  fromRoot,
  moduleWithSystem,
  inputs,
  ...
}:
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

          scope-with-overrides = lib.makeScope pkgs.newScope (_: {
            rustPlatform_nightly = pkgs.makeRustPlatform {
              rustc = rust-toolchain;
              cargo = rust-toolchain;
            };
          });
        in
        lib.packagesFromDirectoryRecursive {
          inherit (scope-with-overrides) callPackage newScope;
          directory = fromRoot "pkgs/by-name";
        }
        // {
          neovim = inputs.mnw.lib.wrap {
            inherit pkgs;
            inherit (inputs) mnw;
          } (fromRoot "pkgs/nvim");
        };
    };

  flake.modules.generic.otherpkgs = moduleWithSystem (
    { config }:
    {
      _module.args.otherpkgs = config.legacyPackages;
    }
  );
}
