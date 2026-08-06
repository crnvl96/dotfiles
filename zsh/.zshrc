path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.local/bin"

export PATH

env_file="${XDG_CONFIG_HOME:-$HOME/.config}/shell/.env.local"

if [[ -f "$env_file" && -r "$env_file" ]]; then
  set -a
  source "$env_file"
  set +a
else
  printf 'dotfiles: %s is not present; skipping local environment\n' "$env_file" >&2
fi

export EDITOR="nvim"
export VISUAL=$EDITOR
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export _ZO_RESOLVE_SYMLINKS="1"

alias lzg='lazygit'
alias ex='exit'
alias cl='clear'
alias nv='nvim'
alias nt='scratchpad'
alias pin='pi --no-session'
alias ls='eza -l'
alias la='eza -la'
alias cat='bat'

eval "$(mise activate zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# bun completions
[ -s "/Users/velozient/.bun/_bun" ] && source "/Users/velozient/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
