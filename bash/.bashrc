export PATH="$PATH:$HOME/.asdf/shims:$HOME/.local/bin"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

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
alias gd="git difftool --dir-diff"
alias gb="git branch"
alias gp="git fetch --all --prune && git pull --rebase"

source $HOME/.config/bash/git-prompt.sh
source $HOME/.config/bash/git-completion.sh

PS1='[\j][\W$(__git_ps1 " (%s)")]\n\$ '

if [ -n "$NVIM" ]; then
    export EDITOR="nvim --server $NVIM --remote"
    export VISUAL="$EDITOR"
    alias nvim="$EDITOR"
else
    export EDITOR="nvim"
    export VISUAL="$EDITOR"
fi

export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
export WEZTERM_CONFIG_FILE="$HOME/.config/wezterm/wezterm.lua"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --files --hidden --follow --glob "!.git/*" --null | xargs -0 dirname | sort | uniq"


export _ZO_RESOLVE_SYMLINKS=1

. <(asdf completion bash)

eval "$(fzf --bash)"
eval "$(zoxide init --cmd x bash)"
