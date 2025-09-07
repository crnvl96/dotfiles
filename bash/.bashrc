# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

alias lzg='lazygit'
alias ex='exit'
alias cl='clear'
alias nv='nvim'
alias y='yazi'

export RIPGREP_CONFIG_PATH=~/.ripgreprc

PATH=$PATH:$HOME/.local/scripts/

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'
#
# Use VSCode instead of neovim as your default editor
# export EDITOR="code"
#
# Set a custom prompt with the directory revealed (alternatively use https://starship.rs)
# PS1="\W \[\e]0;\w\a\]$PS1"
