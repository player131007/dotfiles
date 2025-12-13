{ sources, lib, ... }:
let
  inherit (builtins) substring unsafeDiscardStringContext isPath;
in
{
  nixpkgs.config.allowUnfree = true;

  nix = {
    registry.nixpkgs.to = {
      type = "path";
      path = sources.nixpkgs.outPath;
    };
    nixPath = [ "nixpkgs=${sources.nixpkgs.outPath}" ];
  };

  # only the outPath changes when we override so we gotta go nuclear
  system.nixos =
    let
      path =
        let
          inherit (sources.nixpkgs) outPath;
        in
        if isPath outPath then outPath else /. + unsafeDiscardStringContext outPath;
      revision = if lib.path.hasStorePathPrefix path then sources.nixpkgs.revision else "dirty";
    in
    {
      inherit revision;
      versionSuffix = if revision == "dirty" then ".dirty" else ".${substring 0 8 revision}";
    };
}
