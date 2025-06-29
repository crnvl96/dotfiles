yay -S --noconfirm --needed tmux

echo -e '\nif [ -f ~/.bashrc ]; then\n    source ~/.bashrc\nfi' >> ~/.bash_profile

TMUX_BASHRC_BLOCK="
# Auto start tmux in interactive shell, except in IDEs/terminals
if command -v tmux &> /dev/null \\
  && [ \"\$TERM_PROGRAM\" != \"vscode\" ] \\
  && [ -n \"\$PS1\" ] \\
  && [[ ! \"\$TERM\" =~ screen ]] \\
  && [[ ! \"\$TERM\" =~ tmux ]] \\
  && [[ ! \"\$TERMINAL_EMULATOR\" =~ \"JetBrains-JediTerm\" ]] \\
  && [ -z \"\$TMUX\" ]; then
    tmux attach-session -t default || tmux new-session -s default
    return
fi
"

# Avoid duplicating the block
if ! grep -Fq "tmux attach-session -t default" ~/.bashrc; then
  echo "$TMUX_BASHRC_BLOCK" >> ~/.bashrc
fi
