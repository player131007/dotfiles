{ pkgs, ... }:
{
    environment.systemPackages = [ pkgs.eza ];
    programs.bash.interactiveShellInit = ''
        if [[ "$TERM" == "linux" ]]; then
            eza_use_icons=never
        else
            eza_use_icons=auto
        fi
    '';
    programs.fish.interactiveShellInit = ''
        if [ "$TERM" = "linux" ]
            set eza_use_icons never
        else
            set eza_use_icons auto
        end
    '';
    
    environment.shellAliases = {
        l = "eza --icons=$eza_use_icons -Flha";
        ls = "eza --icons=$eza_use_icons -F";
        ll = "eza --icons=$eza_use_icons -Flh";
    };
}
