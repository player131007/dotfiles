{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  wrappers ? import ./wrappers.nix { inherit sources pkgs; },
}:
pkgs.mkShellNoCC {
  allowSubstitutes = false; # Prevent a cache.nixos.org call every time
  packages = [
    wrappers.obs
    wrappers.looking-glass
    wrappers.less
    wrappers.git
    wrappers.diff-so-fancy
    wrappers.bash
    wrappers.nix-index
    wrappers.fish
    wrappers.nushell
  ];
}
