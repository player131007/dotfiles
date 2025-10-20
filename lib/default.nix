{ lib }:
{
  recursivelyImport = import ./recursivelyImport.nix { inherit lib; };
}
