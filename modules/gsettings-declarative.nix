{ inputs, ... }:
{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      gsettings.package =
        let
          gsettings-declarative = import "${inputs.nix-maid}/gsettings-declarative" { inherit pkgs; };
        in
        gsettings-declarative.overrideAttrs (prevAttrs: {
          nativeBuildInputs = prevAttrs.nativeBuildInputs or [ ] ++ [
            pkgs.glib
          ];
          buildInputs = prevAttrs.buildInputs or [ ] ++ [
            pkgs.gsettings-desktop-schemas
          ];
        });
    };
}
