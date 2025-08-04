---
--- Global Variables
---

_G.HOME = os.getenv('HOME')
_G.NVIM_DIR = HOME .. '/.config/nvim'
_G.MINI_PATH = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'

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
--- Package Manager
---

if not vim.loop.fs_stat(MINI_PATH) then
  local clone_cmd = {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim',
    MINI_PATH,
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { snapshot = NVIM_DIR .. '/mini-deps-snap' } })
require('mini.icons').setup()

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
--- Settings
---

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

---
--- Plugins
---

MiniDeps.now(function()
  MiniDeps.add({ name = 'mini.nvim' })
  MiniDeps.add('neovim/nvim-lspconfig')
  MiniDeps.add('tpope/vim-fugitive')
end)

---
--- Mason
---

MiniDeps.now(function()
  MiniDeps.add({
    source = 'mason-org/mason.nvim',
    hooks = {
      post_checkout = function() vim.cmd('MasonUpdate') end,
    },
  })

  require('mason').setup()

  MiniDeps.later(function()
    local mr = require('mason-registry')

    mr.refresh(function()
      for _, tool in ipairs({
        -- Formatters
        'stylua',
        'prettier',

        -- Language servers
        'gopls',
        'biome',
        'css-lsp', -- cssls
        'eslint-lsp', -- eslint
        'lua-language-server', -- lua_ls
        'pyright',
        'ruff',
        'typescript-language-server', -- ts_ls
        'tailwindcss-language-server', -- tailwindcss
        'jq', -- json
      }) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
      end
    end)
  end)
end)

---
--- Treesitter
---

MiniDeps.now(function()
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    checkout = 'main',
    hooks = {
      post_checkout = function() vim.cmd('TSUpdate') end,
    },
  })

  local parsers = {
    'c',
    'lua',
    'prisma',
    'vim',
    'vimdoc',
    'query',
    'markdown',
    'markdown_inline',
    'javascript',
    'typescript',
    'tsx',
    'jsx',
    'python',
    'rust',
  }

  require('nvim-treesitter').install(parsers)

  local group = vim.api.nvim_create_augroup('crnvl96-treesitter', {})

  local callback = function(e)
    local filetype = e.match
    local lang = vim.treesitter.language.get_lang(filetype) or ''
    if vim.treesitter.language.add(lang) then
      vim.bo[e.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.treesitter.start()
    end
  end

  vim.api.nvim_create_autocmd('FileType', { group = group, callback = callback })
end)

---
--- Conform.nvim - code formatter
---

MiniDeps.later(function()
  MiniDeps.add('stevearc/conform.nvim')

  local function get_root_dir(root_files, bufnr)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
  end

  local function get_web_formatter(bufnr)
    if get_root_dir({ 'biome.json', 'biome.jsonc' }, bufnr) then
      return { 'biome', 'biome-check', 'biome-organize-imports' }
    else
      return { 'prettier' }
    end
  end

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  vim.g.conform = true

  require('conform').setup({
    notify_on_error = true,
    formatters = { injected = { ignore_errors = true } },
    formatters_by_ft = {
      ['_'] = { 'trim_whitespace', 'trim_newlines' },
      json = { 'jq' },
      jsonc = { 'jq' },
      css = get_web_formatter,
      javascript = get_web_formatter,
      javascriptreact = get_web_formatter,
      typesCRipt = get_web_formatter,
      typescriptreact = get_web_formatter,
      lua = { 'stylua' },
      markdown = { 'prettier', 'injected' },
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      rust = { 'rustfmt' },
    },
    format_on_save = function() return vim.g.conform and { timeout_ms = 3000, lsp_format = 'fallback' } end,
  })
end)

---
--- Fzf-lua.nvim - general fuzzy finder
---

MiniDeps.later(function()
  MiniDeps.add('ibhagwan/fzf-lua')

  local actions = require('fzf-lua').actions
  require('fzf-lua').setup({
    'hide',
    fzf_opts = {
      ['--cycle'] = '',
    },
    actions = {
      files = {
        true,
        ['enter'] = actions.file_edit_or_qf,
        ['ctrl-s'] = actions.file_split,
        ['ctrl-v'] = actions.file_vsplit,
        ['ctrl-t'] = actions.file_tabedit,
        ['alt-x'] = actions.file_sel_to_qf,
        ['alt-X'] = actions.file_sel_to_ll,
        ['alt-i'] = actions.toggle_ignore,
        ['alt-h'] = actions.toggle_hidden,
        ['alt-f'] = actions.toggle_follow,
      },
    },
    winopts = {
      preview = {
        vertical = 'down:45%',
        horizontal = 'right:60%',
        layout = 'flex',
        flip_columns = 150,
      },
    },
    keymap = {
      fzf = {
        ['ctrl-q'] = 'select-all+accept',
        ['ctrl-r'] = 'toggle+down',
        ['ctrl-e'] = 'toggle+up',
        ['ctrl-a'] = 'select-all',
        ['ctrl-o'] = 'toggle-all',
        ['ctrl-u'] = 'half-page-up',
        ['ctrl-d'] = 'half-page-down',
        ['ctrl-x'] = 'jump',
        ['ctrl-f'] = 'preview-page-down',
        ['ctrl-b'] = 'preview-page-up',
      },
      builtin = {
        ['<c-f>'] = 'preview-page-down',
        ['<c-b>'] = 'preview-page-up',
      },
    },
  })

  require('fzf-lua').register_ui_select()

  vim.keymap.set('n', '<Leader>f', function() require('fzf-lua').files() end, { desc = 'Files' })
  vim.keymap.set('n', '<Leader>l', function() require('fzf-lua').blines() end, { desc = 'Lines' })
  vim.keymap.set('n', '<Leader>g', function() require('fzf-lua').live_grep() end, { desc = 'Grep' })
  vim.keymap.set('x', '<Leader>g', function() require('fzf-lua').grep_visual() end, { desc = 'Grep' })
  vim.keymap.set('n', '<Leader>b', function() require('fzf-lua').buffers() end, { desc = 'Buffers' })
  vim.keymap.set('n', "<Leader>'", function() require('fzf-lua').resume() end, { desc = 'Resume' })
  vim.keymap.set('n', '<Leader>x', function() require('fzf-lua').quickfix() end, { desc = 'Quickfix' })
end)

---
--- Mini.files - nvim file manager
---

MiniDeps.later(function()
  local minifiles = require('mini.files')

  local function map_split(bufnr, lhs, direction)
    local function rhs()
      local window = minifiles.get_explorer_state().target_window

      if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

      local new_target_window
      vim.api.nvim_win_call(window, function()
        vim.cmd(direction .. ' split')
        new_target_window = vim.api.nvim_get_current_win()
      end)

      minifiles.set_target_window(new_target_window)
      minifiles.go_in({ close_on_file = true })
    end

    vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = 'Split ' .. string.sub(direction, 12) })
  end

  minifiles.setup({
    mappings = {
      show_help = '?',
      go_in_plus = '<CR>',
      go_out_plus = '-',
      go_in = '',
      go_out = '',
    },
  })

  vim.keymap.set('n', '-', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then minifiles.open(bufname, false) end
  end)

  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    group = vim.api.nvim_create_augroup('crnvl96-minifiles', {}),
    callback = function(e)
      local bufnr = e.data.buf_id
      map_split(bufnr, '<C-w>s', 'belowright horizontal')
      map_split(bufnr, '<C-w>v', 'belowright vertical')
    end,
  })
end)
