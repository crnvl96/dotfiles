# asdf
PATH=$HOME/.asdf/shims:$PATH

# aliases
alias ls="eza -l"
alias la="eza -lA"
alias lzd="$HOME/.asdf/installs/golang/1.23.5/packages/bin/lazydocker"
alias lzg="$HOME/.asdf/installs/golang/1.23.5/packages/bin/lazygit"
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
alias sv="source .venv/bin/activate"
alias z="zellij"

# yazi file manager
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

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

# Wezterm
export WEZTERM_CONFIG_FILE="$HOME/.config/wezterm/wezterm.lua"

# Ruby
export GEM_HOME="$HOME/gems"
PATH=$HOME/gems/bin:$PATH

# fzf
# Use ripgrep (rg) as the default finder source
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --files --hidden --follow --glob "!.git/*" --null | xargs -0 dirname | sort | uniq"

# path
export PATH=$HOME/.local/bin:$PATH

# Zoxide
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init --cmd x bash)"
