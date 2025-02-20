local node_path = os.getenv('HOME') .. '/.asdf/installs/nodejs/22.14.0'
local asdf_path = os.getenv('HOME') .. '/.asdf/shims'

vim.env.PATH = asdf_path .. ':' .. node_path .. '/bin:' .. vim.env.PATH
vim.env.NODE_PATH = node_path

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamedplus'
vim.o.cmdheight = 1
vim.o.conceallevel = 0
vim.o.cursorline = false
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
vim.o.number = false
vim.o.numberwidth = 3
vim.o.relativenumber = false
vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.shortmess = 'ascWICF'
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
vim.opt.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60'

vim.diagnostic.config({
    float = { border = 'rounded', source = true },
    virtual_text = true,
    update_in_insert = true,
    virtual_lines = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN] = 'W',
            [vim.diagnostic.severity.HINT] = 'H',
            [vim.diagnostic.severity.INFO] = 'I',
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        },
    },
})

if vim.fn.exists('syntax_on') ~= 1 then vim.cmd('syntax enable') end
vim.cmd('filetype plugin indent on')
vim.cmd('packadd cfilter')

local methods = vim.lsp.protocol.Methods
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)

local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
    show = function(ns, bufnr, diagnostics, opts)
        table.sort(diagnostics, function(diag1, diag2) return diag1.severity > diag2.severity end)
        return show_handler(ns, bufnr, diagnostics, opts)
    end,
    hide = hide_handler,
}

vim.lsp.util.stylize_markdown = function(bufnr, contents, opts)
    contents = vim.lsp.util._normalize_markdown(contents, {
        width = vim.lsp.util._make_floating_popup_size(contents, opts),
    })
    vim.bo[bufnr].filetype = 'markdown'
    vim.treesitter.start(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    return contents
end

local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then return end

    Utils.OnAttach(client, vim.api.nvim_get_current_buf())

    return register_capability(err, res, ctx)
end
