if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux a -t default || exec tmux new -s default && exit;
fi

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

alias ci='zi'
alias lzg='lazygit'
alias ex='exit'
alias cl='clear'
alias nv='nvim'
alias y='yazi'

export RIPGREP_CONFIG_PATH=~/.ripgreprc

export FZF_DEFAULT_OPTS="--cycle \
    --multi \
    --border='none' \
    --border-label='none' \
    --preview-window='border-none' \
    --separator='' \
    --scrollbar='' \
    --layout='reverse-list' \
    --info='default' \
    --bind 'ctrl-x:toggle' \
    --bind 'ctrl-o:select-all' \
    --bind 'ctrl-z:toggle-all'"


export FZF_DEFAULT_COMMAND="fd . \
    --path-separator / \
    --strip-cwd-prefix \
    --type f \
    --hidden \
    --follow \
    --exclude .git"

PATH=$PATH:$HOME/.local/scripts/

. "/home/adran/.local/share/bob/env/env.sh"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
# Use VSCode instead of neovim as your default editor
# export EDITOR="code"
#
# Set a custom prompt with the directory revealed (alternatively use https://starship.rs)
# PS1="\W \[\e]0;\w\a\]$PS1"
