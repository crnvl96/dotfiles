#!/bin/bash

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

# Toggle zoom state of the current pane
tmux resize-pane -Z
