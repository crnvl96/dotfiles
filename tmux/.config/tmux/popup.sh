#!/bin/bash

# Default dimensions for the popup (can be overridden by arguments)
WIDTH=${1:-95%}
HEIGHT=${2:-95%}
SESSION_NAME="popup"

# Check if tmux is running
if ! command -v tmux &> /dev/null; then
    echo "Error: tmux is not installed."
    exit 1
fi

# Check if already in a tmux session
if [ -z "$TMUX" ]; then
    echo "Error: Not in a tmux session."
    exit 1
fi

# Toggle popup: if in popup session, detach; otherwise, open or attach to popup
if [ "$(tmux display-message -p -F "#{session_name}")" = "$SESSION_NAME" ]; then
    tmux detach-client
else
    tmux popup -d '#{pane_current_path}' -xC -yC -w"$WIDTH" -h"$HEIGHT" \
        "tmux attach-session -t $SESSION_NAME 2>/dev/null || tmux new-session -s $SESSION_NAME"
fi

exit 0
