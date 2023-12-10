{ pkgs, ... }: {
    programs.fish = {
        enable = true;
        plugins = [
            {
                name = "puffer";
                src = pkgs.fetchFromGitHub {
                    owner = "nickeb96";
                    repo = "puffer-fish";
                    rev = "5d3cb25e0d63356c3342fb3101810799bb651b64";
                    hash = "sha256-aPxEHSXfiJJXosIm7b3Pd+yFnyz43W3GXyUB5BFAF54=";
                };
            }
        ];
        interactiveShellInit = ''
            set -g fish_greeting
            fish_config theme choose "Rosé Pine"
        '';
    };
}
