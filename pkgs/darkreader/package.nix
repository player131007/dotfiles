{
  buildNpmPackage,
  background ? "181a1b",
  text ? "e8e6e3",
  darkMode ? true,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "darkreader";
  version = "4.9.106";

  src = fetchFromGitHub {
    owner = "darkreader";
    repo = "darkreader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yJ/nOLaDL4MfZ/JxlUk5pyDefEeNZzOTPrbWCiMx+E4=";
  };

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
