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

# Ruby
export GEM_HOME="$HOME/gems"

# Haskell
[ -f "/home/crnvl96/.ghcup/env" ] && . "/home/crnvl96/.ghcup/env"

# Path
export PATH="$HOME/.local/bin:$HOME/gems/bin:$PATH"

# asdf
. "$HOME/.asdf/asdf.sh"

# fzf

# Use ripgrep (rg) as the default finder source
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --files --hidden --follow --glob "!.git/*" --null | xargs -0 dirname | sort | uniq"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   tmux a -t default || exec tmux new -s default && exit;
# fi

# MUST BE AT THE END!!!
# Zoxide
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init --cmd x bash)"
