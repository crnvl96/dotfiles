# Personal dotfiles

These are some simple tweaks I did on top of [Omarchy](https://omarchy.org/), and are not meant to be used without it

# Installation process

1. Follow completely the [Omarchy installation instructions](https://manuals.omamix.org/2/the-omarchy-manual/50/getting-started)

2. Install required packages

   ```bash
   yay -S --noconfirm --needed stow ansible
   ```

3. Clone this Repository and cd into it

   ```bash
   git clone https://github.com/crnvl96/dotfiles.git ~/Dotfiles >/dev/null
   ```

4. Decrypt the ssh keys

   ```bash
   cd ~/Dotfiles/ssh/.ssh
   ```

   ```bash
   ansible-vault decrypt target.encrypted --output target
   ```

5. Run the following commands:

   ```bash
   rm -rf ~/.config/nvim/*
   ```

   ```bash
   stow -t ~ --adopt * && git restore .
   ```

# Ansible

If for some reason we need to replace the ssh keys, the process is the following:

1. [Generate new ssh keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

2. Encrypt them:

   ```bash
   ansible-vault encrypt target --output target.encrypted
   ```
