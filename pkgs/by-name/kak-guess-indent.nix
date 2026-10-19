{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kak-guess-indent";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "guess-indent.kak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ppJmiKvLzPDeZRM6p5ZuZkoOFyrbQY3Fx8QSB65DI5I=";
  };

  cargoHash = "sha256-EU50c5EYMQ1e2gRaGkR5XLm3wLwzAtcfc9r2+TSus5Q=";

  strictDeps = true;
  __structuredAttrs = true;
})
