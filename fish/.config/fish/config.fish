set -g fish_greeting
source ~/.asdf/asdf.fish

set -gx PROJECTS $HOME/Developer
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx BROWSER firefox
set -gx PATH $HOME/.asdf/shims $HOME/.local/bin $PATH
set -gx GPG_TTY (tty) # This is for signing git commits with gpg
set -gx PGCLUSTER 15/main

set -gx RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config

set -gx FZF_DEFAULT_OPTS '
  --height=100%
  --color=fg:-1,fg+:#c6c8d1,bg:-1,bg+:#161821
  --color=hl:#e2a478,hl+:#e2a478,info:#afaf87,marker:#b4be8c
  --color=prompt:#e27878,spinner:#84a0c6,pointer:#84a0c6,header:#87afaf
  --color=border:#262626,query:#d9d9d9
  --border=sharp --preview-window=border-sharp
  --padding=2 --margin=2 --prompt="> " --marker=">"
  --pointer=">" --layout=reverse-list
  --info=inline
'

set -Ux FZF_DEFAULT_COMMAND '
  fd --hidden --follow --type file --type symlink
'

set -Ux _ZO_ECHO 1
set -Ux _ZO_RESOLVE_SYMLINKS 1

alias fortivpn="/opt/forticlient/fortivpn "
alias lzg="$HOME/.config/lazygit/symlink_workaround.sh"
alias lzd="lazydocker"
alias t="tree --gitignore -a -L "
alias tar_compress_dir_into_file="tar czf"
alias tar_unconpress_file_into_dir="tar xzf"
alias vimz="vim (fd --strip-cwd-prefix --hidden --follow --type file | fzf)"
alias lfz="lf (fd --strip-cwd-prefix --hidden --follow --type file | fzf)"
alias ccd="cd (fd --strip-cwd-prefix --hidden --follow --type directory | fzf)"
alias ex="exit"
alias cl="clear"
alias ls="eza -l --color=auto"
alias la="eza -lA"
alias tp="trash-put "
alias g="git"
alias gs="git st" # git status
alias gc="git cm" # git commit
alias gl="git lg" # enhanced git log
alias gr="git restore"
alias gx="git reset"
alias gp="git pull"
alias gP="git push"
alias ga="git add"
alias gA="git add ."
alias gap="git ap" # git add --patch
alias gd="git df" # git diff
alias gds="git ds" # git diff --staged
alias gcp="git commit && git push" # git commit && push
alias golang_coverage="go test -coverprofile=cover.out ./..."
alias golang_coverage_html="go tool cover -html=cover.out"
alias golang_bench="go test -bench "

zoxide init fish | source
starship init fish | source

set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
