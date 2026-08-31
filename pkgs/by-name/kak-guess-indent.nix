{
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kak-guess-indent";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "guess-indent.kak";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qSra1/bPRF+UXH95tINbIU1WVeibaFVq5ybbatTqbwQ=";
  };

  cargoHash = "sha256-UYuAU/cikHyH0F8mrA4M6G0eLdcjscEuiMxEZJ1v0E8=";

  strictDeps = true;
  __structuredAttrs = true;

  postInstall = ''
    mkdir -p $out/share/kak
    cp -r $src/rc $out/share/kak/autoload
  '';
})
