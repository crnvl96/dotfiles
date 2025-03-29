local methods = vim.lsp.protocol.Methods
local register_capability = vim.lsp.handlers[methods.client_registerCapability]

vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.loaded_netrwPlugin = 1

local node_path = '/home/crnvl96/.asdf/installs/nodejs/22.14.0'

vim.g.node_host_prog = node_path .. '/bin/node'
vim.env.PATH = node_path .. '/bin:' .. vim.env.PATH

vim.o.background = 'light'

vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.cursorline = false
vim.o.expandtab = true
vim.opt.fillchars:append('eob: ')
vim.o.foldcolumn = '0'
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevel = 99
vim.o.clipboard = 'unnamedplus'
vim.o.foldlevelstart = 99
vim.o.grepprg = 'rg --vimgrep'
vim.o.ignorecase = true
vim.o.infercase = true
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
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
vim.o.termguicolors = false
vim.o.timeoutlen = 1000
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.writebackup = false
vim.o.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60'

vim.opt.completeopt:append('fuzzy,noselect')
vim.opt.wildoptions:append('fuzzy')

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

if vim.o.background == 'dark' then
    vim.cmd([[colorscheme ham]])
else
    vim.cmd([[colorscheme ham_light]])
end

vim.diagnostic.config({
    float = { source = true },
    virtual_text = true,
    update_in_insert = true,
    virtual_lines = false,
    signs = false,
})

vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    Utils.OnAttach(client, vim.api.nvim_get_current_buf())
    return register_capability(err, res, ctx)
end
