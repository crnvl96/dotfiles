path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.local/share/pnpm/bin"
path_prepend "$HOME/.opencode/bin"

export PATH

env_file="${XDG_CONFIG_HOME:-$HOME/.config}/shell/.env.local"

set -a
source "$env_file"
set +a

export EDITOR="nvim"
export VISUAL="nvim"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export _ZO_RESOLVE_SYMLINKS="1"

eval "$(mise activate zsh)"

alias lzg='lazygit'
alias ex='exit'
alias cl='clear'
alias nv='nvim'
alias so='source .venv/bin/activate'
alias nt='scratchpad'
alias pin='pi --no-session'
alias ls='eza -l'
alias la='eza -la'
alias cat='bat'

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
