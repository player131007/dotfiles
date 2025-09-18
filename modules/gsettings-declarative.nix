{ inputs, ... }:
{
  flake.modules.maid.pc =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      options.gsettings.extraSchemaPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };

      config.gsettings.package =
        let
          gsettings-declarative = import "${inputs.nix-maid}/gsettings-declarative" { inherit pkgs; };
        in
        gsettings-declarative.overrideAttrs (prevAttrs: {
          buildInputs = prevAttrs.buildInputs or [ ] ++ config.gsettings.extraSchemaPackages;
        });
    };
}
