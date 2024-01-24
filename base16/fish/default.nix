{ config, ... }: {
    programs.fish.interactiveShellInit = ''
        source ${config.scheme {
            template = ./fish.mustache;
            extension = ".fish";
        }}
    '';
}
