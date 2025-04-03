-------------------------------------------------------------
-------------------------------------------------------------
--- A quick tutorial about using Oil with ssh connections ---
-------------------------------------------------------------
-------------------------------------------------------------

-- !/bin/sh
--
--  The agnostic command is (https://github.com/stevearc/oil.nvim?tab=readme-ov-file#ssh):
--  nvim oil-ssh://[user]@[host]:[port]/[path]
--
--  A simple script to copying files over ssh connections is:
--  #!/bin/bash
--  HOST=$1
--  PORT=$2
--  PATH=$3
--
--  scp -P ${PORT} *.py root@${HOST}:${PATH}
--  scp -P ${PORT} requirements.txt root@${HOST}:${PATH}
--
--  So, for example, given the connection `ssh root@194.26.196.142 -p 12826` and the project path being `/app/myproject`
--  194.26.196.142 is the HOST
--  12826 is the PORT
--  /app/myproject is the PATH
--
--  So, you would run ./script.sh 194.26.196.142 12826 /app/myproject
--
--  After that, you could connect with the ssh by running:
--  ssh -L 4004:localhost:6006 root@194.26.196.142 -p 12826 (where 4404 is your local port, and 6606 is the remote machine port)
--
--  A ssh config entry would look like this:
--
--  Host runpod
--    Hostname 194.26.196.142
--    User root
--    Port 12826
--    LocalForward 4004 localhost:6006
--    ServerAliveInterval 180
--    ServerAliveCountMax 4
--
--  Or, you could run just like this: `nvim oil-ssh://root@194.26.196.142:12826/app/myproject`

local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
    local clone_cmd = {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/echasnovski/mini.nvim',
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd('packadd mini.nvim | helptags ALL')
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup()

MiniDeps.add({ name = 'mini.nvim' })

vim.cmd([[colorscheme ham]])

NodePath = '/home/crnvl96/.asdf/installs/nodejs/22.14.0'
Methods = vim.lsp.protocol.Methods
RegisterCapability = vim.lsp.handlers[Methods.client_registerCapability]
LBin = vim.env.HOME .. '/.local/bin/'
ASDFNode = vim.env.HOME .. '/.asdf/installs/nodejs/22.14.0/bin/'
ASDFRust = vim.env.HOME .. '/.asdf/installs/rust/1.84.1/bin/'
ASDFGo = vim.env.HOME .. '/.asdf/installs/golang/1.23.5/bin/'
Brew = '/home/linuxbrew/.linuxbrew/bin/'
Adapter = 'anthropic'

vim.g.fmtoff = false
vim.o.background = 'light'

vim.env.PATH = NodePath .. '/bin:' .. vim.env.PATH

vim.lsp.enable({
    'basedpyright',
    'biome',
    'eslint',
    'harper_ls',
    'lua_ls',
    'ruff',
    'vtsls',
})
