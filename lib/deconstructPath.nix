# shamelessly borrowed from lib/path/default.nix
# why isn't this public?
{ ... }:
let
  inherit (builtins) baseNameOf dirOf;
  recurse =
    components: base:
    # If the parent of a path is the path itself, then it's a filesystem root
    if base == dirOf base then
      {
        root = base;
        inherit components;
      }
    else
      recurse ([ (baseNameOf base) ] ++ components) (dirOf base);
in
recurse [ ]
