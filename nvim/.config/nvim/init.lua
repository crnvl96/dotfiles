vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.whoami = "crnvl96"

vim.filetype.add({
	filename = {
		[".eslintrc.json"] = "jsonc",
	},
	pattern = {
		["tsconfig*.json"] = "jsonc",
		[".*/%.vscode/.*%.json"] = "jsonc",
	},
})

vim.opt.autoindent = true
vim.opt.background = "dark"
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.completeopt = "menu,menuone,noinsert,noselect"
vim.opt.cursorline = true
vim.opt.diffopt:append("context:99")
vim.opt.expandtab = true
vim.opt.fillchars = "vert:│,fold:۰,diff:·,stl:─,stlnc:═"
vim.opt.foldenable = false
vim.opt.foldmethod = "indent"
vim.opt.formatoptions = "qjl"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.hidden = true
vim.opt.hls = true
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.joinspaces = false
vim.opt.laststatus = 2
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = "tab:  ,trail:~,eol:↵"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.path:append("**")
vim.opt.shortmess:append("I")
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.shiftround = true
vim.opt.shiftwidth = 4
vim.opt.showcmd = false
vim.opt.pumheight = 7
vim.opt.re = 0
vim.opt.report = 0
vim.opt.signcolumn = "yes"
vim.opt.sidescrolloff = 16
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spellsuggest = "best,10"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.tags = "./tags,./../tags,./*/tags"
vim.opt.termguicolors = true
vim.opt.timeoutlen = 200
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.updatetime = 200
vim.opt.virtualedit = "block"
vim.opt.whichwrap:append("<,>,h,l")
vim.opt.wildignore:append("*/node_modules/*,*/dist/*,*/.cache/*")
vim.opt.wildoptions = "pum"
vim.opt.wrap = false

vim.g["denops#deno"] = vim.fn.stdpath("data") .. "/mason/bin/deno"

local vim = vim
local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- basic essentials
Plug("vim-denops/denops.vim")
Plug("williamboman/mason.nvim", { ["do"] = ":MasonUpdate" })
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })

Plug("tpope/vim-sleuth")
Plug("christoomey/vim-tmux-navigator")
Plug("tpope/vim-fugitive")
Plug("justinmk/vim-dirvish")

Plug("lewis6991/gitsigns.nvim")
Plug("stevearc/conform.nvim")
Plug("mfussenegger/nvim-lint")
Plug("echasnovski/mini.nvim")

Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/nvim-cmp")

Plug("ibhagwan/fzf-lua")
Plug("williamboman/mason-lspconfig.nvim")
Plug("neovim/nvim-lspconfig")
Plug("sainnhe/edge")

vim.call("plug#end")

vim.g.edge_better_performance = 1
vim.g.edge_enable_italic = 1
vim.g.edge_style = "aura"
vim.cmd("colorscheme edge")
