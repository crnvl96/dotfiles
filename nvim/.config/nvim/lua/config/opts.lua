local fn = vim.fn
local g = vim.g
local o = vim.o
local opt = vim.opt

return function()
    g.mapleader = ' '
    g.maplocalleader = ','

    o.splitbelow = true
    o.splitright = true
    o.guicursor = ''
    o.cursorline = false
    o.showcmd = false
    o.showmode = false
    o.ruler = false
    o.laststatus = 0
    o.foldcolumn = '0'
    o.foldenable = true
    o.foldlevel = 99
    o.foldlevelstart = 99
    o.foldmethod = 'expr'
    o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    o.formatexpr = "v:lua.require'conform'.formatexpr()"
    o.swapfile = false
    o.virtualedit = 'block'
    o.splitkeep = 'screen'
    o.shiftround = true
    o.shiftwidth = 2
    o.tabstop = 2
    o.expandtab = true
    o.scrolloff = 8
    o.sidescrolloff = 4
    o.breakindent = true
    o.smartindent = true
    o.smartcase = true
    o.ignorecase = true
    o.infercase = true
    o.mouse = 'a'
    o.number = true
    o.relativenumber = true
    o.clipboard = 'unnamedplus'
    o.signcolumn = 'yes'
    o.fillchars = 'eob: '
    o.termguicolors = true
    o.undofile = true
    o.updatetime = 300
    o.timeoutlen = 1000
    o.backup = false
    o.writebackup = false
    o.wrap = false
    o.wildignorecase = true
    o.background = 'dark'

    opt.formatoptions:append('l1')
    opt.shortmess:append('WcC')
    opt.diffopt:append('linematch:60')
    opt.wildoptions:append('fuzzy')
    opt.path:append('**')
    opt.wildignore:append('*/node_modules/*,*/dist/*')
    opt.completeopt:append('menuone,noinsert,noselect,popup,fuzzy')

    if fn.executable('rg') ~= 0 then o.grepprg = 'rg --vimgrep' end
    if fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end

    vim.cmd('filetype plugin indent on')
    vim.cmd('packadd cfilter')
end
