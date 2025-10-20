source ~/.local/share/omarchy/default/bash/rc

alias lzg='lazygit'
alias ex='exit'
alias cl='clear'
alias nv='nvim'
alias dt='dirt -t ~/Developer -t ~/.config/nvim'
alias nvim='~/.local/nvim-linux-x86_64/bin/nvim'
alias nv='~/.local/nvim-linux-x86_64/bin/nvim'
alias n='~/.local/nvim-linux-x86_64/bin/nvim'

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

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
