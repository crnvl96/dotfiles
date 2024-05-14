# Dotfiles

Files important enough for version control

# Contents

- [Installation](#installation)
  + [Requirements](#requirements)
  + [Installation Guide](#installation-guide)
- [Mirror List](#mirror-list)

# Installation

## Requirements
  - [Git](https://git-scm.com/)
  - [Gnu Stow](https://www.gnu.org/software/stow/)

## Installation guide

Clone the Repository via http or ssh:

```bash
# http
git clone https://github.com/crnvl96/dotfiles.git
```

```bash
# ssh
git clone git@github.com:crnvl96/dotfiles.git
```

Execute the following `stow` command:

**Important: it will try to seed _all_ files currently inside yout `dotfiles` directory into your filesystem**

```bash
# trigger stow command in verbose mode for easy debugging
stow -t $HOME */ -vvv
```

# Mirror List

| Repository     | Mirror                                |
| -------------- | ------------------------------------- |
| `github.com`   | https://github.com/crnvl96/dotfiles   |
| `codeberg.org` | https://codeberg.org/crnvl96/dotfiles |
