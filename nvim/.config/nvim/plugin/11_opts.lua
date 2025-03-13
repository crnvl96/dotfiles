vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.loaded_netrwPlugin = 1

vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamed'
vim.o.cmdheight = 1
vim.o.conceallevel = 0
vim.o.cursorline = false
vim.o.expandtab = true
vim.opt.fillchars:append('eob: ')
vim.o.foldcolumn = '0'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.guicursor = ''
vim.o.grepprg = 'rg --vimgrep'
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = ''
vim.o.mousescroll = 'ver:2,hor:6'
vim.o.number = true
vim.o.numberwidth = 3
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showcmd = false
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.softtabstop = 4
vim.o.spell = false
vim.o.spell = false
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = 'useopen'
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.timeoutlen = 1000
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wrap = false
vim.o.writebackup = false
vim.o.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60'

vim.opt.completeopt:append('fuzzy')
vim.opt.wildoptions:append('fuzzy')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')
vim.cmd([[colorscheme ham]])
