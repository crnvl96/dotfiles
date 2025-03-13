#!/bin/sh

# The agnostic command is (https://github.com/stevearc/oil.nvim?tab=readme-ov-file#ssh):
# nvim oil-ssh://[user]@[host]:[port]/[path]

# A simple script to copying files over ssh connections is:
# #!/bin/bash
# HOST=$1
# PORT=$2
# PATH=$3
#
# scp -P ${PORT} *.py root@${HOST}:${PATH}
# scp -P ${PORT} requirements.txt root@${HOST}:${PATH}

# So, for example, given the connection `ssh root@194.26.196.142 -p 12826` and the project path being `/app/myproject`
# 194.26.196.142 is the HOST
# 12826 is the PORT
# /app/myproject is the PATH
#
# So, you would run ./script.sh 194.26.196.142 12826 /app/myproject
#
# After that, you could connect with the ssh by running:
# ssh -L 4004:localhost:6006 root@194.26.196.142 -p 12826 (where 4404 is your local port, and 6606 is the remote machine port)
#
# A ssh config entry would look like this:
#
# Host runpod
#   Hostname 194.26.196.142
#   User root
#   Port 12826
#   LocalForward 4004 localhost:6006
#   ServerAliveInterval 180
#   ServerAliveCountMax 4
#
# Or, you could run just like this: `nvim oil-ssh://root@194.26.196.142:12826/app/myproject`

# This script is used to easily open an SSH connection through the Neovim Oil file manager.
# Before using this script you need to make it executable with `$ chmod +x oil-ssh.sh`.
# Usage: `$ ./oil-ssh.sh` (or `$ oil` with an alias)

# Select a host via fzf
host=$(grep 'Host\>' ~/.ssh/config | sed 's/^Host //' | grep -v '\*' | fzf --cycle --layout=reverse)

if [ -z "$host" ]; then
	exit 0
fi

# Get user from host name
user=$(ssh -G "$host" | grep '^user\>'  | sed 's/^user //')

nvim oil-ssh://"$user"@"$host"/
