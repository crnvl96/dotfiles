vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- https://github.com/olimorris/codecompanion.nvim/tree/main/lua/codecompanion/adapters
vim.g.codecompanion_adapter = 'deepseek'
vim.g.autoformat = true

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamedplus'
vim.o.cmdheight = 1
vim.o.conceallevel = 0
vim.o.cursorline = true
vim.opt.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60'
vim.o.expandtab = true
vim.o.foldcolumn = '0'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.grepprg = 'rg --vimgrep'
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.laststatus = 0
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:2,hor:6'
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 2
vim.o.showcmd = false
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spell = false
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = 'usetab'
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeoutlen = 100
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wrap = false
vim.o.writebackup = false

vim.opt.fillchars:append('eob: ')

vim.diagnostic.config({
  float = { border = 'rounded', source = true },
  virtual_lines = { current_line = true },
})

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')
