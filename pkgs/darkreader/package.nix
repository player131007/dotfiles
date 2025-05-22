{
  lib,
  buildNpmPackage,
  background ? "181a1b",
  text ? "e8e6e3",
  darkMode ? true,
  npins-nixpkgs,
}:
buildNpmPackage (finalAttrs: {
  pname = "darkreader";
  version = lib.removePrefix "v" finalAttrs.src.version;
  src = npins-nixpkgs.darkreader;

  # bruh
  npmDepsHash = "sha256-uA3/uv5ZNa2f4l2ZhmNCzX+96FKlQCq4XlK5QkfYQQU=";

  patches = [ ./default-theme.patch ];
  postPatch = ''
    substituteInPlace ./src/defaults.ts \
      --subst-var-by background ${background} \
      --subst-var-by text ${text} \
      --subst-var-by darkMode ${if darkMode then "1" else "0"}
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
})
