{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
  wrappers ? import ./wrappers.nix { inherit sources pkgs; },
}:
let
  inherit (builtins) mapAttrs attrValues;
in
rec {
  default = pkgs.mkShellNoCC {
    allowSubstitutes = false; # Prevent a cache.nixos.org call every time

    packages =
      (
        removeAttrs wrappers [ "self" ]
        |> mapAttrs (_name: module: module { }) # this is here to make the expr not a single line
        |> attrValues
      )
      ++ [
        pkgs.nixfmt
        pkgs.nixd
      ];
  };

  glide = pkgs.mkShellNoCC {
    allowSubstitutes = false;
    packages = [
      pkgs.typescript-go
      pkgs.esbuild
      (wrappers.glide-browser { })
    ];

    inputsFrom = [ default ];
  };
}
