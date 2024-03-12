function tmux_list_sessions
    set selected (tmux list-sessions -F "#{session_name}" | # list all tmux sessions
        fzf-tmux -p --no-sort --cycle --prompt "Select a session: ")

    tmux switch-client -t "$selected"
end
