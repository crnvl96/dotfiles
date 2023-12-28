function tmux_session_clean
    tmux switch-client -t base
    test "$(tmux list-sessions | wc -l)" -gt 1 && tmux list-sessions |
        grep -v "^base:" |
        cut -f1 -d':' |
        xargs -n 1 tmux kill-session -t
end
