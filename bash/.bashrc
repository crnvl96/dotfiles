alias lzg='lazygit'
alias ex='exit'
alias cl='clear'
alias nv='nvim'
alias dt='dirt -t ~/Developer -t ~/.config/nvim -t ~/.emacs.d'

# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# fzf
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

# bun
export BUN_INSTALL="$HOME/.bun"
PATH="$BUN_INSTALL/bin:$PATH"

# uv
PATH="/home/crnvl96/.local/share/../bin:$PATH"

export PATH

eval "$(/home/adran/.local/bin/mise activate bash)" # added by https://mise.run/bash
