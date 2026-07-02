# dotfiles

Personal Linux dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Each top-level directory is one stow package; `stow.sh` symlinks them into place.

## Prerequisites

- `stow` — `sudo apt install stow`
- `sudo` — required only for the `keyd` package
- [mise](https://mise.jdx.dev/) — manages most of the CLI tools referenced by the configs (see `mise/.config/mise/config.toml`)
- [Homebrew on Linux](https://brew.sh/), [starship](https://starship.rs/), [zoxide](https://github.com/ajeetdsouza/zoxide), [keyd](https://github.com/rvaiya/keyd) — referenced from `bash/.bashrc` or system configs; install only what you want to use

## Install

```sh
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./stow.sh            # user packages → $HOME, keyd → /etc/keyd (sudo)
```

`stow.sh` prints each command and asks for confirmation before running.
Use `--fresh` to unstow everything first, or `--help` for full options.

## Packages

| Package    | Target                  | Notes                                              |
|------------|-------------------------|----------------------------------------------------|
| `bash`     | `$HOME`                 | `~/.bashrc`                                        |
| `git`      | `$HOME`                 | `.gitconfig`, global gitignore                     |
| `kitty`    | `$HOME/.config/kitty`   | Terminal config                                    |
| `lazygit`  | `$HOME/.config/lazygit` |                                                    |
| `mise`     | `$HOME/.config/mise`    | Tool versions + env; see `config.toml`             |
| `ripgrep`  | `$HOME`                 | `~/.ripgreprc`                                     |
| `keyd`     | `/etc/keyd` (via sudo)  | System-wide key remap; requires the `keyd` daemon  |

## Per-machine env

The `mise` package references `~/.config/mise/.env.local`, which is gitignored.
Create it with any secrets you need; the variable names are listed in
`config.toml`'s `redactions` array.
