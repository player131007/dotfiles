{
    fetchFromGitHub,
    buildNpmPackage,
    background ? "18131b",
    text ? "e8e6e3",
    isDarkTheme ? true
}: let
    version = "4.9.87";
in buildNpmPackage {
    pname = "darkreader";
    inherit version;

    src = fetchFromGitHub {
        owner = "darkreader";
        repo = "darkreader";
        rev = "v${version}";
        hash = "sha256-MBe2GKXLw8A/e1d+rljYEV6BrKLNRXPUbLbnwnM3XRQ=";
    };

    npmDepsHash = "sha256-ET7U1OE/kmQd507i9Sr4PNJ78VKd8iS3QG3m7h/0tak=";

    prePatch = let
        mode = if isDarkTheme then "1" else "0";
    in ''
        sed -i "
            s/\(background: '#\)[0-9A-Fa-f]\{6\}/\1${background}/g;
            s/\(text: '#\)[0-9A-Fa-f]\{6\}/\1${text}/g;
            s/mode: 1/mode: ${mode}/g;
        " src/defaults.ts
    '';

    npmBuildFlags = ["--" "--firefox"];

    installPhase = ''
        runHook preInstall
        cp -r build $out/
        runHook postInstall
    '';
}
