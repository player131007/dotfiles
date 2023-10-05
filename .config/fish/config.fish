if status is-interactive
    fish_config theme choose "Rosé Pine"
    function mark_prompt_start --on-event fish_prompt
	    echo -en "\e]133;A\e\\"
    end
    abbr --add ls eza -F --icons --header
    abbr --add ll eza -F --icons --header -l
    abbr --add la eza -F --icons --header -la

    starship init fish | source
end
