{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [
        pkgs.wlr-randr
        pkgs.wl-clipboard
        pkgs.swaylock
      ];
    };
}
