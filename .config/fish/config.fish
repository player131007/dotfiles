if status is-interactive
    fish_config theme choose "Rosé Pine"
    function mark_prompt_start --on-event fish_prompt
	    echo -en "\e]133;A\e\\"
    end
    abbr --add ls exa -F --icons --header
    abbr --add ll exa -F --icons --header -l
    abbr --add la exa -F --icons --header -la
end
