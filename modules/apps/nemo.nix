{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.nemo ];
      gsettings.extraSchemaPackages = [ pkgs.nemo ];
      gsettings.settings = {
        org.nemo.preferences.desktop-is-home-dir = true;
      };
    };
}
