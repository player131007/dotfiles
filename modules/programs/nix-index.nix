{
  lib,
  myLib,
  myPkgs,
  pkgs,
  sources,
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

  nix-index-wrapped = pkgs.symlinkJoin {
    inherit (nix-index) pname version;
    paths = [ nix-index ];

    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      makeWrapper ${nix-index}/bin/nix-locate $out/bin/nix-locate --inherit-argv0 --set NIX_INDEX_DATABASE ${nix-index-db}
      makeWrapper ${nix-index}/bin/command-not-found $out/bin/command-not-found --inherit-argv0 --set NIX_INDEX_DATABASE ${nix-index-db-bin-only}
    '';
  };

  command-not-found-nu = pkgs.writeTextDir "share/nushell/vendor/autoload/command-not-found.nu" ''
    $env.config.hooks.command_not_found = [{ |cmd| command-not-found $cmd | print }]
  '';
in
{
  programs.command-not-found.enable = false;

  environment.systemPackages = [ nix-index-wrapped ];

  stuff.nushell.vendors = [ command-not-found-nu ];

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
