local node_path = os.getenv('HOME') .. '/.asdf/installs/nodejs/20.17.0'

if vim.fn.isdirectory(node_path) == 1 then
    vim.env.PATH = node_path .. '/bin:' .. vim.env.PATH
    vim.env.NODE_PATH = node_path

    vim.notify('Node.js path set to: ' .. node_path, 'INFO')
else
    vim.notify('Invalid Node.js path: ' .. node_path, 'ERROR')
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.autoindent = true
vim.o.autoread = true
vim.o.breakindent = true
vim.o.clipboard = 'unnamedplus'
vim.o.cmdheight = 1
vim.o.conceallevel = 0
vim.o.cursorline = true
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
vim.o.numberwidth = 3
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
vim.o.statuscolumn = '%l%s'
vim.o.swapfile = false
vim.o.switchbuf = 'usetab'
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeoutlen = 1000
vim.o.undofile = true
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wrap = false
vim.o.writebackup = false
vim.opt.diffopt = 'filler,internal,closeoff,algorithm:histogram,context:5,linematch:60'
vim.opt.fillchars:append('eob: ')

vim.diagnostic.config({
    float = { border = 'rounded', source = true },
    virtual_text = false,
    virtual_lines = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
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
