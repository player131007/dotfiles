{
  runCommandLocal,
  fetchFromGitHub,
}:
runCommandLocal "nix-direnv"
  {
    src = fetchFromGitHub {
      owner = "nix-community";
      repo = "nix-direnv";
      rev = "a7555e961eed5095bda856b69d9349ee5cf5ed99";
      hash = "sha256-3XeZsgIHQxyceeJ50/NB9IyH3J+wbiTLMcdmx4n6Iq0=";
    };
  }
  ''
    install -Dm 444 $src/direnvrc $out/share/nix-direnv/direnvrc
  ''
