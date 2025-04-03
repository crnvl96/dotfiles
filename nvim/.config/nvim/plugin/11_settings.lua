vim.g.disable_autoformat = false
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
vim.g.node_host_prog = NodePath .. '/bin/node'

vim.o.autoindent = true
vim.o.autoread = true
vim.o.background = 'dark'
vim.o.breakindent = true
vim.o.clipboard = 'unnamedplus'
vim.o.cursorline = false
vim.o.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60'
vim.o.expandtab = true
vim.o.foldcolumn = '0'
vim.o.foldcolumn = '0'
vim.o.foldenable = true
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = 'expr'
vim.o.foldtext = ''
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.o.grepprg = 'rg --vimgrep --smart-case'
vim.o.makeprg = 'make'
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

vim.opt.fillchars:append({ eob = ' ', fold = ' ' })
vim.opt.completeopt:append('fuzzy,noselect')
vim.opt.wildoptions:append('fuzzy')

vim.opt.statusline = table.concat({
    ' %f', -- File path
    ' %m%r%h%w', -- File flags (modified, readonly, etc.)
    ' %{%v:lua.StatuslineDiagnostics()%}', -- Diagnostics
    '%=', -- Right align the rest
    '%{%v:lua.CodeCompanionStatusline()%}', -- CodeCompanion status
    ' %y', -- File type
    ' %l:%c ', -- Line and column
    ' %p%% ', -- Percentage through file
}, '')

if vim.o.background == 'dark' then
    vim.cmd([[colorscheme ham]])
else
    vim.cmd([[colorscheme ham_light]])
end

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

vim.diagnostic.config({
    float = { source = true },
    virtual_text = true,
    update_in_insert = true,
    virtual_lines = false,
    signs = false,
})

vim.lsp.handlers[Methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end
    OnAttach(client, vim.api.nvim_get_current_buf())
    return RegisterCapability(err, res, ctx)
end
