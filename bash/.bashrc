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

source ~/.config/bash/git_completion.bash
source ~/.config/bash/git_prompt.sh

PS1="[\u@\h \W$(__git_ps1 ' (%s)')]\$ "

alias ls="eza -l"
alias la="eza -lA"
alias cat="bat "
alias cl="clear"
alias ex="exit"
alias lzd="lazydocker"
alias lzg="lazygit"
alias nv="nvim"

alias gl="git log --oneline"
alias gb="git branch"
alias gs="git status"
alias gd="git diff"
alias ga="git add "
alias gap="git add -p "
alias gc="git commit -m "

if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

eval "$(zoxide init --cmd x bash)"
