export PATH="$PATH:$HOME/.asdf/shims:$HOME/gems/bin:$HOME/.local/bin"
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
alias sv="source .venv/bin/activate"
alias z="zellij"
alias oil='~/.config/nvim/static/scripts/oil-ssh.sh'
alias chr='docker run -v ./chroma-data:/data -p 8000:8000 chromadb/chroma:latest'
alias cursor='/opt/cursor.appimage --no-sandbox'

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

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
export GEM_HOME="$HOME/gems"
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="rg --files --hidden --follow --glob "!.git/*" --null | xargs -0 dirname | sort | uniq"
export HELIX_RUNTIME=$HOME/.local/state/helix/runtime


export _ZO_RESOLVE_SYMLINKS=1

. <(asdf completion bash)

eval "$(fzf --bash)"
eval "$(zoxide init --cmd x bash)"
