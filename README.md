# Personal dotfiles

These are some simple tweaks I did on top of [Omarchy](https://omarchy.org/), and are not meant to be used without it

# Installation process

1. Follow completely the [Omarchy installation instructions](https://manuals.omamix.org/2/the-omarchy-manual/50/getting-started)
2. Setup a [ssh key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) (Signin and Authentication)
3. Install [GNU Stow](https://www.gnu.org/software/stow/) via `yay -S --noconfirm --needed stow`
4. Clone this Repo at the home (~) directory, and `cd` into it
5. Run `stow --adopt *`
