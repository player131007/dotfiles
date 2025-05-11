_: prev:
let
  src = (prev.lib.importJSON ../npins/sources.json).pins.darkreader;
  darkreader =
    {
      lib,
      fetchFromGitHub,
      buildNpmPackage,
      background ? "18131b",
      text ? "e8e6e3",
      isDarkTheme ? true,
    }:
    buildNpmPackage {
      pname = "darkreader";
      version = lib.removePrefix "v" src.version;

      src = fetchFromGitHub {
        inherit (src.repository) owner repo;
        rev = src.revision;
        sha256 = src.hash;
      };

      # bruh
      npmDepsHash = "sha256-uA3/uv5ZNa2f4l2ZhmNCzX+96FKlQCq4XlK5QkfYQQU=";

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
