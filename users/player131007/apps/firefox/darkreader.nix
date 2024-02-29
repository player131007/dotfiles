{
    fetchFromGitHub,
    buildNpmPackage,
    background ? "18131b",
    text ? "e8e6e3",
    isDarkTheme ? true,
}: let
    version = "4.9.78";
in buildNpmPackage {
    pname = "darkreader";
    inherit version;

    src = fetchFromGitHub {
        owner = "darkreader";
        repo = "darkreader";
        rev = "v${version}";
        hash = "sha256-jU82aajKmZ9rLGEClMRzi89XMKNsUBgyXJxVtYWnGVc=";
    };

    npmDepsHash = "sha256-BnQU3CbLZY9UdH2MJ0hJL86Z+tdeeFT/m/7WhcDWY7g=";

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
