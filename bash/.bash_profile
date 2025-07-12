[[ -z $DISPLAY && $(tty) == /dev/tty1 ]] && exec Hyprland

# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
