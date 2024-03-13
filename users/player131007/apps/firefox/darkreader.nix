{
    fetchFromGitHub,
    buildNpmPackage,
    background ? "18131b",
    text ? "e8e6e3",
    isDarkTheme ? true,
}: let
    version = "4.9.79";
in buildNpmPackage {
    pname = "darkreader";
    inherit version;

    src = fetchFromGitHub {
        owner = "darkreader";
        repo = "darkreader";
        rev = "v${version}";
        hash = "sha256-FY5ZEQB7HeVljxXFSwOyJv8auR87bh03yjJPS8IwlCQ=";
    };

    npmDepsHash = "sha256-hR/VTcrTsB/uMmNSSAQ16+DYcHVcGY9H1+d3gFWraaM=";

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
