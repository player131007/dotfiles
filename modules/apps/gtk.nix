{ inputs, ... }:
{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.adw-gtk3 ];
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
      gsettings.settings = {
        org.gnome.desktop.interface.gtk-theme = "adw-gtk3";
      };
    };
}
