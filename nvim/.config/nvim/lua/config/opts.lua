vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.timeoutlen = 200
vim.opt.updatetime = 200
vim.opt.laststatus = 0
vim.opt.showtabline = 0

vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cmdheight = 2
vim.opt.showcmd = false

vim.opt.virtualedit = "block"
vim.opt.inccommand = "split"

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.scrolloff = 8

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.swapfile = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/vim/undo"
vim.opt.undofile = true

vim.opt.completeopt = { "menu", "menuone", "noselect", "noinsert" }
vim.opt.shortmess:append("c")

vim.opt.path = "."
