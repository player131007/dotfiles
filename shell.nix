{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  wrappers ? import ./wrappers.nix { inherit sources pkgs; },
}:
let
  inherit (builtins) mapAttrs attrValues;

  base = [
    (wrappers.kakoune { })
    pkgs.nixfmt
    pkgs.nixd
  ];
in
{
  default = pkgs.mkShellNoCC {
    allowSubstitutes = false; # Prevent a cache.nixos.org call every time

    packages =
      (
        removeAttrs wrappers [ "self" ]
        |> mapAttrs (_name: module: module { }) # this is here to make the expr not a single line
        |> attrValues
      )
      ++ base;
  };

  glide = pkgs.mkShellNoCC {
    allowSubstitutes = false;
    packages = [
      pkgs.typescript-go
      pkgs.esbuild
      (wrappers.glide-browser { })
    ]
    ++ base;
  };
}
