{
  pkgs,
  lib,
  sources,
  myLib,
  myPkgs,
  ...
}:
let
  inherit (myPkgs) nix-index;
  inherit (import sources.nix-index-cache { inherit pkgs; }) nix-index-cache;

  nix-index-db = pkgs.callPackage (myLib.fromRoot "pkgs/nix-index-db.nix") {
    inherit nix-index nix-index-cache;
  };

  nix-index-db-bin-only =
    (nix-index-db.override {
      extraArgs = lib.escapeShellArgs [
        "--filter-prefix=/bin/"
        "--compression=9"
      ];
    }).overrideAttrs
      { name = "nix-index-db-bin-only"; };

  nix-index-wrapped =
    pkgs.runCommandLocal "nix-index-wrapped" { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; }
      ''
        mkdir -p $out/bin
        makeWrapper ${nix-index}/bin/nix-locate $out/bin/nix-locate --inherit-argv0 --set NIX_INDEX_DATABASE ${nix-index-db}
        makeWrapper ${nix-index}/bin/command-not-found $out/bin/command-not-found --inherit-argv0 --set NIX_INDEX_DATABASE ${nix-index-db-bin-only}
      '';
in
{
  programs.command-not-found.enable = false;

  environment.systemPackages = [
    nix-index-wrapped
    nix-index
  ];

  programs.bash.interactiveShellInit = /* bash */ ''
    command_not_found_handle() {
      command-not-found "$1"
    }
  '';

  programs.fish.interactiveShellInit = /* fish */ ''
    function fish_command_not_found
      command-not-found $argv[1]
    end
  '';
}
