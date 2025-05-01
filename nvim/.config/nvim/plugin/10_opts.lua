local default_nodejs = vim.env.HOME .. '/.local/share/mise/installs/node/22.14.0/bin/'
vim.g.node_host_prog = default_nodejs .. 'node'
vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

vim.o.fillchars = table.concat({
    'diff:/',
    'eob:~',
    'fold:╌',
}, ',')

vim.o.listchars = table.concat({
    'precedes:…',
    'extends:…',
    'nbsp:␣',
    'tab:  ',
}, ',')

vim.o.diffopt = table.concat({
    'internal',
    'filler',
    'closeoff',
    'context:5',
    'algorithm:histogram',
    'linematch:60',
    'indent-heuristic',
    -- 'inline:word',
}, ',')

vim.o.grepprg = table.concat({
    'rg',
    '--vimgrep',
    '--smart-case',
}, ' ')

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.breakindent = true
vim.o.clipboard = 'unnamed'
vim.o.conceallevel = 0
vim.o.cursorline = false
vim.o.expandtab = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.laststatus = 0
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showcmd = false
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.softtabstop = 4
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.writebackup = false
