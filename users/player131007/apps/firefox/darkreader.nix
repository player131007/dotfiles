{
    fetchFromGitHub,
    buildNpmPackage,
    background ? "18131b",
    text ? "e8e6e3",
    isDarkTheme ? true,
}: let
    version = "4.9.80";
in buildNpmPackage {
    pname = "darkreader";
    inherit version;

    src = fetchFromGitHub {
        owner = "darkreader";
        repo = "darkreader";
        rev = "v${version}";
        hash = "sha256-h3qs2OCk6rkLXd3mm/GUrvGkzmjpARe+shV/4QxO3Y8=";
    };

    npmDepsHash = "sha256-XlJYneMcZhg7KL7PHmjap/98Noxxnf4G97NPd3rgJZw=";

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
