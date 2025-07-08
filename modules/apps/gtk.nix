{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      # set theme manually
      packages = [ pkgs.adw-gtk3 ];
    };
}
