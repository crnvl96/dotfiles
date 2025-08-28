-- Opts ================================================================

-- Path ================================================================
-- Command to find the current node version (v22.x is the lts) installed by mise
-- Tracking about versions can be found at https://nodejs.org/en/about/previous-releases
-- This is needed to avoid nvim reading a wrong node version due to a project setting it at its root folder

local node_version =
  vim.fn.system("mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'"):gsub('\n', '')

if node_version == '' then
  vim.notify(
    'Could not determine Node.js version from mise. Please ensure mise is installed and a Node.js version is set.',
    vim.log.levels.WARN
  )
else
  local default_nodejs = HOME .. '/.local/share/mise/installs/node/' .. node_version .. '/bin/'
  vim.g.node_host_prog = default_nodejs .. 'node'
  vim.env.PATH = default_nodejs .. ':' .. vim.env.PATH
end

vim.ui.select = require('mini.pick').ui_select

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  float = { source = true },
  signs = true,
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.o.background = 'dark'
vim.o.completeopt = 'menuone,noselect,noinsert'
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'
vim.o.ignorecase = true
vim.o.laststatus = 0
vim.o.linebreak = true
vim.o.list = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:3,hor:0'
vim.o.number = true
vim.o.pumheight = 15
vim.o.relativenumber = true
vim.o.clipboard = 'unnamed'

vim.cmd([[
if executable('rg')
    set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case\ --hidden
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
]])

vim.o.ruler = false
vim.o.scrolloff = 8
vim.o.shiftwidth = 4
vim.o.showcmd = false
vim.o.sidescrolloff = 24
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 10
vim.o.undofile = true
vim.o.updatetime = 300
vim.o.virtualedit = 'block'
vim.o.wildignorecase = true
vim.o.wildmode = 'longest:full'
vim.o.winborder = 'single'
vim.o.wrap = false
vim.o.writebackup = false

vim.opt.listchars = { trail = '.', tab = '  ' }
vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:4',
  'algorithm:histogram',
  'linematch:60',
  'indent-heuristic',
  'vertical',
  'context:99',
}
vim.opt.fillchars = { eob = ' ', fold = ' ', foldclose = '', foldopen = '', foldsep = ' ', msgsep = '─' }

vim.opt.wildignore:append({ '.DS_Store' })
vim.opt.wildoptions:append('fuzzy')
vim.opt.shortmess:append({ a = true, s = true, W = true })

vim.cmd([[filetype plugin indent on]])
vim.cmd([[set wildmode=noselect:lastused,full]])
vim.cmd([[set wc=^N]])
vim.cmd([[packadd cfilter]])
