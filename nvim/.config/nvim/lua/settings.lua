---
--- Settings
---

---
--- Colorscheme
---

vim.cmd.colorscheme('ansi')

---
--- NodeJS path
---

local node_version_cmd = "mise ls --cd ~ | grep '^node' | grep '22\\.' | head -n 1 | awk '{print $2}'"
local node_version = vim.fn.system(node_version_cmd):gsub('\n', '')

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

---
--- Load LSP servers
---

local lsp_dir = NVIM_DIR .. '/lsp'
local excluded_servers = {}
local lsp_servers = {}

for _, file in ipairs(vim.fn.glob(lsp_dir .. '/*.lua', true, true)) do
  local server_name = vim.fn.fnamemodify(file, ':t:r')
  if not vim.tbl_contains(excluded_servers, server_name) then
    table.insert(lsp_servers, server_name)
    local chunk = assert(loadfile(file))
    vim.lsp.config(server_name, chunk())
  end
end

vim.lsp.enable(lsp_servers)

---
--- Diagnostics
---

vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false,
  float = { source = true },
  signs = false,
})

---
--- Filetypes
---

vim.filetype.add({
  filename = {
    ['.eslintrc.json'] = 'jsonc',
  },
  pattern = {
    ['tsconfig*.json'] = 'jsonc',
    ['.*/%.vscode/.*%.json'] = 'jsonc',
    ['.*'] = function(path, bufnr)
      return vim.bo[bufnr]
          and vim.bo[bufnr].filetype ~= 'bigfile'
          and path
          and vim.fn.getfsize(path) > (1024 * 500) -- 500kb
          and 'bigfile'
        or nil
    end,
  },
})

---
--- Opts
---

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrw = 1

vim.o.timeoutlen = 1000
vim.o.scrolloff = 8
vim.o.sidescrolloff = 24
vim.o.wrap = false
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.laststatus = 2
vim.o.linebreak = true
vim.o.ignorecase = true
vim.o.wildignorecase = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'
vim.o.virtualedit = 'block'
vim.o.winborder = 'single'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.undofile = true
vim.o.writebackup = false
vim.opt.fillchars:append('eob: ')

vim.opt.diffopt = {
  'internal',
  'filler',
  'closeoff',
  'context:4',
  'algorithm:histogram',
  'linematch:60',
  'indent-heuristic',
}

---
--- Keymaps
---

vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', 'Y', 'yg_')

vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p', { desc = 'Paste from Clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P', { desc = 'Paste fro Clipboard (before cursor)' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y', { desc = 'Copy to Clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_', { desc = 'Copy line to Clipboard' })

vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')

vim.keymap.set({ 'i', 'n', 'x', 'o' }, '<C-s>', '<Esc>:noh<CR>:w<CR><Esc>')

vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

---
--- Autocmds
---

vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('crnvl96-restore-cursor', {}),
  callback = function(e)
    pcall(vim.api.nvim_win_set_cursor, vim.fn.bufwinid(e.buf), vim.api.nvim_buf_get_mark(e.buf, [["]]))
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-yank-hl', { clear = true }),
  callback = function() vim.hl.on_yank({ higroup = 'Visual', priority = 250 }) end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('crnvl96-big-file', { clear = true }),
  pattern = 'bigfile',
  callback = function(args)
    vim.schedule(function() vim.bo[args.buf].syntax = vim.filetype.match({ buf = args.buf }) or '' end)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('crnvl96-on-lsp-attach', {}),
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)
    if not client then return end

    local methods = vim.lsp.protocol.Methods

    local bufnr = e.buf
    local win = vim.api.nvim_get_current_win()
    local filetype = e.match
    local lang = vim.treesitter.language.get_lang(filetype) or ''

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local set = function(lhs, rhs, opts, mode)
      opts = vim.tbl_extend('error', opts or {}, { buffer = bufnr })
      mode = mode or 'n'
      return vim.keymap.set(mode, lhs, rhs, opts)
    end

    set('E', vim.diagnostic.open_float)
    set('K', vim.lsp.buf.hover)
    set('ga', vim.lsp.buf.code_action)
    set('gn', vim.lsp.buf.rename)
    set('gd', vim.lsp.buf.definition)
    set('gD', vim.lsp.buf.declaration)
    set('gr', vim.lsp.buf.references, { nowait = true })
    set('gi', vim.lsp.buf.implementation)
    set('gy', vim.lsp.buf.type_definition)
    set('ge', vim.diagnostic.setqflist)
    set('gs', vim.lsp.buf.document_symbol)
    set('gS', vim.lsp.buf.workspace_symbol)
    set('<C-k>', vim.lsp.buf.signature_help, {}, 'i')

    if client:supports_method(methods.textDocument_formatting) then
      client.server_capabilities.documentFormattingProvider = true
    end

    if client:supports_method(methods.textDocument_completion) then
      local str = 'abcdefghijklmnopqrstuvwxyz,.:\'"'
      local char_table = {}

      for i = 1, #str do
        char_table[i] = str:sub(i, i)
      end

      client.server_capabilities.completionProvider.triggerCharacters = char_table

      vim.lsp.completion.enable(true, client.id, e.buf, { autotrigger = true })
      vim.cmd('set completeopt+=noselect')
    end

    if client:supports_method(methods.textDocument_foldingRange) then
      vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
    else
      if vim.treesitter.language.add(lang) then vim.wo[win][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()' end
    end
  end,
})
