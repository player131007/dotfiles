{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
  sqlite,

  util-linux,
  makeBinaryWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "nix-index";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "player131007";
    repo = "nix-index";
    rev = "9cb3ccb063fa51343a655443c9cc8d08df3438c5";
    hash = "sha256-R6+qNh/icpG6Yq5WvrfT4w8sswZHQsNRpypmJdIshmk=";
  };

  cargoHash = "sha256-QO7Hq96IrFEhXhyVhti4GnicwEz+aoLAwtDOOOO2ctg=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  buildInputs = [
    openssl
    curl
    sqlite
  ];

  postInstall = ''
    wrapProgram $out/bin/command-not-found --prefix PATH : ${util-linux.bin}/bin
  '';

  meta = with lib; {
    description = "Files database for nixpkgs";
    homepage = "https://github.com/nix-community/nix-index";
    changelog = "https://github.com/nix-community/nix-index/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [
      bennofs
      ncfavier
    ];
  };
}
