let
  sources = import ./npins;
in
{
  pkgs ? import sources.nixpkgs { config.allowUnfree = true; },
  wrappers ? import ./wrappers { inherit pkgs; },
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
    packages =
      (
        removeAttrs wrappers [ "self" ]
        |> mapAttrs (_name: module: module { }) # the comment is here to make the expr not a single line
        |> attrValues
      )
      ++ base;
  };
}
