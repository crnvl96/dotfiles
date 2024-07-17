[[ $- != *i* ]] && return

HISTSIZE=10000

FZF_OPTS="--height 50% --cycle \
  --preview 'bat --style=numbers --color=always {}' \
  --preview-window=hidden \
  --bind 'f4:toggle-preview' \
  --bind 'ctrl-f:preview-half-page-down' \
  --bind 'ctrl-b:preview-half-page-up' \
  --bind 'ctrl-o:toggle-all' \
  --prompt '> ' \
  --delimiter '│'"

LOCAL_BIN="$HOME/.local/bin"

export BROWSER="firefox"
export EDITOR="vim"
export VISUAL="vim"

export BUN_INSTALL="$HOME/.bun"
export BUN_BIN="$BUN_INSTALL/bin"

export PATH=$LOCAL_BIN:$BUN_BIN:$PATH

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS="$FZF_OPTS"

export _ZO_FZF_OPTS="$FZF_OPTS"
export _ZO_RESOLVE_SYMLINKS=1

export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

alias ls="eza -l"
alias la="eza -lA"
alias cat="bat "
alias cl="clear"
alias ex="exit"
alias lzd="lazydocker"
alias lzg="lazygit"

alias nv="nvim"

alias g="git"
alias gs="git status"
alias gl="git log --oneline"
alias gd="git diff"
alias gp="git pull --rebase"
alias gf="git fetch --all --prune"
alias gc="git commit"
alias gcn="git commit --no-verify"
alias gpu="git push origin HEAD"
alias gpun="git push origin HEAD --no-verify"

alias pvc="pavucontrol"
alias display="$HOME/.local/scripts/display"

if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="no-cursor"
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

eval "$(zoxide init --cmd x bash)"

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ "$CURRENT_EDITOR" != "zed" ]; then
  tmux a -t base || tmux new -s base;
  exit;
fi

# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   tmux a -t base || tmux new -s base;
#   exit;
# fi
