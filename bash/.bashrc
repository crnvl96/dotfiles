. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

[[ $- != *i* ]] && return

source $HOME/.config/bash/git-prompt.sh
source $HOME/.config/bash/git-completion.sh
source $HOME/.config/bash/tmux-completion

PS1='[\j][\W$(__git_ps1 " (%s)")]\n\$ '
HISTSIZE=10000

export FZF_DEFAULT_COMMAND='rg --files'

FZF_OPTS="--height 50% --cycle \
  --preview 'bat --style=numbers --color=always {}' \
  --preview-window=hidden \
  --bind 'f4:toggle-preview' \
  --bind 'ctrl-f:preview-half-page-down' \
  --bind 'ctrl-b:preview-half-page-up' \
  --bind 'ctrl-o:toggle-all' \
  --bind 'alt-a:select-all' \
  --prompt '> ' \
  --delimiter '│'"

export BROWSER="brave-browser"
export PATH=$HOME/.local/bin:$PATH

if [ -n "$NVIM" ]; then
    export EDITOR="nvim --server $NVIM --remote"
    alias nvim="$EDITOR"
else
    export EDITOR="nvim"
fi

export VISUAL="$EDITOR"

export FZF_DEFAULT_OPTS="$FZF_OPTS"

export _ZO_FZF_OPTS="$FZF_OPTS"
export _ZO_RESOLVE_SYMLINKS=1

export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

alias ls="eza -l"
alias la="eza -lA"
alias cat="bat "
alias cl="clear"
alias ex="exit"
alias lzd="lazydocker"
alias lzg="lazygit"
alias nv="nvim"

alias g="git"
alias gb="git branch"
alias gs="git status"
alias gl="git log --all --oneline --graph --decorate"
alias gd="git diff"
alias gb="git branch"
alias gp="git pull --rebase"
alias gfp="git fetch --all && git fetch --prune && git pull --rebase"
alias gc="git commit"
alias gcn="git commit --no-verify"
alias gpu="git push origin HEAD"
alias gpun="git push origin HEAD --no-verify"

alias pvc="pavucontrol"
alias display="$HOME/.local/scripts/display"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval "$(zoxide init --cmd x bash)"

# if command -v tmux &> /dev/null && [[ $- == *i* ]] && [[ ! "$TERM" =~ screen|tmux ]] && [ -z "$TMUX" ]; then
#   tmux attach-session -t main || exec tmux new-session -s main
# fi
