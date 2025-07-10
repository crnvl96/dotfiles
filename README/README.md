# Personal dotfiles

These are some simple tweaks I did on top of [Omarchy](https://omarchy.org/), and are not meant to be used without it

# Installation process

1. Follow completely the [Omarchy installation instructions](https://manuals.omamix.org/2/the-omarchy-manual/50/getting-started)

2. Install required packages

   ```bash
   yay -S --noconfirm --needed stow
   ```

3. Configure ssh keys if needed

   ```bash
   ssh-keygen -t ed25519 -C "adran@hey.com"
   ```

4. Clone this Repository and cd into it

   ```bash
   git clone git@github.com:crnvl96/dotfiles.git ~/Dotfiles >/dev/null
   ```

5. Run the stow commands

   ```bash
   rm -rf ~/.config/nvim/* # necessary because omarchy installs Lazyvim in the system
   ```

   ```bash
   stow -R -t ~ --ignore=^/README.* --adopt * && git restore .
   ```
