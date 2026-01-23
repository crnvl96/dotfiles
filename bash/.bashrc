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

# uv
PATH="/home/adr/.local/share/../bin:$PATH"
PATH="/home/adr/.local/bin:$PATH"

# opencode
PATH=/home/adr/.opencode/bin:$PATH

# mise
eval "$(mise activate bash)"

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# cargo (rust)
. "$HOME/.cargo/env"

# path
export PATH
