# Check if tmux is installed
if command -v tmux &> /dev/null &&
   # Check if we're in an interactive shell
   [ -n "$PS1" ] &&
   # Check if we're not already in a screen session
   [[ ! "$TERM" =~ screen ]] &&
   # Check if we're not already in a tmux session (by $TERM)
   [[ ! "$TERM" =~ tmux ]] &&
   # Check if we're not in a JetBrains terminal
   [[ ! "$TERMINAL_EMULATOR" =~ "JetBrains-JediTerm" ]] &&
   # Check if the TMUX variable is not set (another way to detect if we're in tmux)
   [ -z "$TMUX" ]; then
  # Try to attach to existing "default" session or create a new one named "default"
  tmux a -t default || exec tmux new -s default && exit;
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/mise/shims:$PATH"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

alias ls="eza -l"
alias la="eza -lA"
alias lzd="lazydocker"
alias lzg="lazygit"
alias pvc="pavucontrol"
alias bc="sudo brightnessctl"
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
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init --cmd x bash)"
