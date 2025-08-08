local arrows = {
  right = '',
  left = '',
  up = '',
  down = '',
}

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  float = { source = true },
  signs = true,
})

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'

vim.o.timeoutlen = 1000
vim.o.scrolloff = 8
vim.o.sidescrolloff = 24
vim.o.wrap = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.laststatus = 0
vim.o.linebreak = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wildignorecase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:3,hor:0'
vim.o.signcolumn = 'yes'
vim.o.virtualedit = 'block'
vim.o.winborder = 'single'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.writebackup = false
vim.o.foldcolumn = '1'
vim.o.foldlevelstart = 99
vim.wo.foldtext = ''
vim.o.updatetime = 300
vim.o.timeoutlen = 500
vim.o.ttimeoutlen = 10
vim.opt.wildignore:append({ '.DS_Store' })
vim.o.completeopt = 'menuone,noselect,noinsert'
vim.o.pumheight = 15

vim.opt.list = true
vim.opt.listchars = { space = '⋅', trail = '⋅', tab = '  ↦' }

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:4',
  'algorithm:histogram',
  'linematch:60',
  'indent-heuristic',
}

vim.opt.fillchars = {
  eob = ' ',
  fold = ' ',
  foldclose = arrows.right,
  foldopen = arrows.down,
  foldsep = ' ',
  msgsep = '─',
}

vim.opt.diffopt:append('vertical,context:99')

vim.opt.shortmess:append({
  w = true,
  s = true,
})
