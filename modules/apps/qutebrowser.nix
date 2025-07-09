{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = [ pkgs.qutebrowser ];
    };

  # TODO: fill up config
}
