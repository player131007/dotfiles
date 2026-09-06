{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kak-guess-indent";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "guess-indent.kak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rBZW0kFamGMrWq/KpH+/NCpLf4JkM6KbsjLJIsowULo=";
  };

  cargoHash = "sha256-DIR0nMFIN/v0/LzuBxWHDG2Ecxx1/L/CKZHBaKe3+So=";

  strictDeps = true;
  __structuredAttrs = true;

  postInstall = ''
    mkdir -p $out/share/kak
    cp -r $src/rc $out/share/kak/autoload
  '';
})
