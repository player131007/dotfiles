if status is-interactive
    fish_config theme choose "Rosé Pine"
    function mark_prompt_start --on-event fish_prompt
	echo -en "\e]133;A\e\\"
    end
end
