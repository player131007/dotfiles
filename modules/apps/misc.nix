{
  flake.modules.maid.pc =
    { pkgs, ... }:
    {
      packages = builtins.attrValues {
        inherit (pkgs)
          jq
          calc
          brightnessctl
          ripgrep
          xdg-utils
          _7zz
          diff-so-fancy
          ;
      };
    };
}
