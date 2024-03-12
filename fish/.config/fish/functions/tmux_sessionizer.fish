function tmux_sessionizer
    function increase
        set selected "$argv[1]"
        if test "$selected" = default
            return 0
        end
        if test "$selected" = /base
            return 0
        end
        zoxide add $PROJECTS/$selected
    end

    # Declare an array to store the options
    set -l options
    # Add the base option
    set options /base

    for p in (find "$PROJECTS" -maxdepth 1 -type d)
        set options $options (zoxide query -l -s "$p/" | sed "s;$PROJECTS/;;" | grep -v "$PROJECTS" | grep / | sort -rnk1 | uniq | awk '{print $2}')
    end

    set -l tmux_sessions (tmux list-sessions -F "#{session_name}")

    if test (count $argv) -eq 1
        set selected "$argv[1]"
    else
        # Define a function to check if the item is a tmux session and prepend '*'
        set -l tmux_opts
        for i in (seq (count $options))
            set -l item $options[$i]
            set basename (basename $item)
            if contains $basename $tmux_sessions
                set tmux_opts $tmux_opts "  $item"
            else
                set tmux_opts $tmux_opts $item
            end
        end
        set selected (printf '%s\n' $tmux_opts | fzf-tmux -p --cycle)
    end

    if test -z $selected
        exit 0
    end

    set selected_name (basename "$selected" | tr . _)
    set tmux_running (pgrep tmux)

    if test -z "$TMUX" && test -z "$tmux_running"
        if test "$selected" = /base
            tmux new-session -s base -c "$HOME"
        else
            tmux new-session -s "$selected_name" -c "$PROJECTS/$selected"
        end
        increase "$selected"
        exit 0
    end


    if test "$selected" = /base && ! tmux has-session -t="base" 2>/dev/null
        tmux new-session -ds base -c "$HOME"
    else
        if ! tmux has-session -t="$selected_name" 2>/dev/null
            tmux new-session -ds "$selected_name" -c "$PROJECTS/$selected"
        end
    end

    tmux switch-client -t "$selected_name"
    increase "$selected"
end
