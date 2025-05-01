local default_nodejs = vim.env.HOME .. '/.local/share/mise/installs/node/22.14.0/bin/'
vim.g.node_host_prog = default_nodejs .. 'node'
vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH

vim.cmd('packadd cfilter')

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.scrolloff = 8
vim.o.wrap = false

vim.o.ignorecase = true
vim.o.wildignorecase = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'
vim.o.virtualedit = 'block'
vim.o.winborder = 'single'

vim.o.splitbelow = true
vim.o.splitright = true

vim.o.swapfile = false
vim.o.undofile = true
vim.o.writebackup = false
