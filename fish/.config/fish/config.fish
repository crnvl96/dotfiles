set -g fish_greeting
source ~/.asdf/asdf.fish

set -gx PROJECTS $HOME/Developer
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx BROWSER microsoft-edge-stable
set -gx PATH $HOME/.asdf/shims $HOME/.local/bin $HOME/.local/share/nvim/mason/bin $PATH
set -gx GPG_TTY (tty) # This is for signing git commits with gpg

alias fortivpn="/opt/forticlient/fortivpn "
alias lzg="$HOME/.config/lazygit/symlink_workaround.sh"
alias lzd="lazydocker"

alias ex="exit"
alias rm='echo "Use trash-cli instead"; false'
alias cl="clear"
alias ls="eza -l --color=auto"
alias la="eza -lA"
alias cat="bat "

alias nvimz="nvim (fzf)"
alias lfz="lf (fzf)"

alias g="git"
alias gs="git st"
alias gc="git cm"
alias gl="git lg"
alias gr="git restore"
alias gx="git reset"
alias gp="git pull"
alias gP="git push"
alias ga="git add"
alias gA="git add ."
alias gap="git ap"
alias gd="git df"
alias gds="git ds"

set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config
set -Ux FZF_DEFAULT_OPTS '
    --color=bg+:-1,bg:-1,gutter:-1,hl:#FF9E3B,hl+:#FF9E3B
    --color=fg+:#957FB8,fg:#dcd7ba,pointer:#76946a
    --pointer=" " --prompt " " --marker " " --border --cycle'
# set -Ux FZF_DEFAULT_OPTS '
# 	--color=fg:#908caa,bg:-1,hl:#ebbcba
# 	--color=fg+:#e0def4,bg+:-1,hl+:#ebbcba
# 	--color=border:#403d52,header:#31748f,gutter:-1
# 	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
# 	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa --pointer=" " --prompt " " --marker " " --border --cycle'
set -gx FZF_DEFAULT_COMMAND 'fd --type f --strip-cwd-prefix --hidden --follow'

zoxide init fish | source
starship init fish | source
