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
            fish_config theme choose "Rosé Pine"
            function mark_prompt_start --on-event fish_prompt
                echo -en "\e]133;A\e\\"
            end
        '';
    };
}
