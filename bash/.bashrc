source ~/.local/share/omarchy/default/bash/rc

alias lzg='lazygit'
alias ex='exit'
alias cl='clear'
alias nv='nvim'
alias dt='dirt -t ~/Developer -t ~/.config/nvim'

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

. "/home/crnvl96/.local/share/bob/env/env.sh"

eval "$(/home/crnvl96/.local/bin/mise activate bash)" # added by https://mise.run/bash
