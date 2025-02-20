_: prev:
let
  src = (import ../npins).darkreader;
  darkreader =
    {
      buildNpmPackage,
      background ? "18131b",
      text ? "e8e6e3",
      isDarkTheme ? true,
    }:
    buildNpmPackage {
      pname = "darkreader";
      version = builtins.head (builtins.match "v(.+)" src.version);

      inherit src;

      # bruh
      npmDepsHash = "sha256-34GBvRmnJ+TQy6xkDUjSEdvMMGitHWV9Mj3TUf0KSJE=";

      prePatch =
        let
          mode = if isDarkTheme then "1" else "0";
        in
        ''
          sed -i "
              s/\(background: '#\)[0-9A-Fa-f]\{6\}/\1${background}/g;
              s/\(text: '#\)[0-9A-Fa-f]\{6\}/\1${text}/g;
              s/mode: 1/mode: ${mode}/g;
          " src/defaults.ts
        '';

      npmBuildFlags = [
        "--"
        "--firefox"
      ];

      installPhase = ''
        runHook preInstall
        cp -r build $out/
        runHook postInstall
      '';
    };
in
{
  darkreader = prev.callPackage darkreader { };
}
