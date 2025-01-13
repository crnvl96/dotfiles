[[ $- != *i* ]] && return

# git
source $HOME/.config/bash/git-prompt.sh
source $HOME/.config/bash/git-completion.sh

# prompt
PS1='[\j][\W$(__git_ps1 " (%s)")]\n\$ '

# nvim
if [ -n "$NVIM" ]; then
    export EDITOR="nvim --server $NVIM --remote"
		export VISUAL="$EDITOR"
    alias nvim="$EDITOR"
else
    export EDITOR="nvim"
		export VISUAL="$EDITOR"
fi

# rg
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

# aliases
alias ls="eza -l"
alias la="eza -lA"
alias lzd="lazydocker"
alias lzg="lazygit"

alias pvc="pavucontrol"
alias bc="sudo brightnessctl"
alias ar="arandr"

alias cl="clear"
alias ex="exit"

alias nv="nvim"
alias gl="git log --all --oneline --graph --decorate"
alias gs="git status"
alias gb="git branch"
alias gp="git fetch --all --prune && git pull --rebase"

# Wezterm
export WEZTERM_CONFIG_FILE="$HOME/.config/wezterm/wezterm.lua"

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"

[ -f "/home/crnvl96/.ghcup/env" ] && . "/home/crnvl96/.ghcup/env"

# Path
export PATH="$HOME/.local/bin:$HOME/gems/bin:$PATH"

# asdf
. "$HOME/.asdf/asdf.sh"

# MUST BE AT THE END!!!
# Zoxide
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init --cmd x bash)"
