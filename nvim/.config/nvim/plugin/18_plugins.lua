Utils.SetNodePath(os.getenv('HOME') .. '/.asdf/installs/nodejs/20.17.0')

local K = Utils.Keymap

Add('nvim-lua/plenary.nvim')
Add('tpope/vim-fugitive')
Add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })
Add('folke/snacks.nvim')
Add('stevearc/conform.nvim')
Add('olimorris/codecompanion.nvim')
Add('theHamsta/nvim-dap-virtual-text')
Add('mfussenegger/nvim-dap-python')
Add('mfussenegger/nvim-dap')
Add('igorlfs/nvim-dap-view')
Add('saghen/blink.compat')
Add({ source = 'Saghen/blink.cmp', hooks = { post_install = _G.Cargo, post_checkout = _G.Cargo } })
Add('neovim/nvim-lspconfig')
Add('folke/which-key.nvim')

-- Icons provider
require('mini.icons').setup()
-- Treesitter
require('nvim-treesitter.configs').setup(_G.Treesitter())

-- Small (mini) utilities
require('mini.align').setup()
require('mini.ai').setup()
require('mini.splitjoin').setup({ mappings = { toggle = 'gJ' } })
require('mini.operators').setup(_G.MiniOperators())

require('snacks').setup(_G.SnacksSpec())
require('conform').setup(_G.Conform())
require('codecompanion').setup(_G.Codecompanion())
require('dap-view').setup()
require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
require('dap-python').setup('uv')
require('mini.snippets').setup(_G.MiniSnippets())
require('blink.compat').setup()
require('blink.cmp').setup(_G.Blink())
require('which-key').setup(_G.Which_Key())
require('which-key').add(_G.WK_Clues())

---
---
---

for server, config in pairs(_G.Servers()) do
  config = config or {}
  config.capabilities = require('blink.cmp').get_lsp_capabilities()
  require('lspconfig')[server].setup(config)
end

require('dap.ext.vscode').json_decode = function(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)
  return decode(data)
end

vim.print = function(...) require('snacks').debug.inspect(...) end

Snacks.toggle.option('wrap'):map('<leader>uw', { desc = 'Wrap' })
Snacks.toggle.option('relativenumber'):map('<leader>uL', { desc = 'Relnum' })
Snacks.toggle(_G.Autoformat):map('<Leader>uf', { desc = 'Autoformat' })

---
---
---

K('Explorer', { lhs = '<Leader>e', mode = 'n', rhs = _G.Explorer })

K('Buffers', { lhs = '<Leader>b', mode = 'n', rhs = function() Snacks.picker.buffers() end })
K('Files', { lhs = '<Leader>f', mode = 'n', rhs = function() Snacks.picker.files({ hidden = true }) end })
K('Grep', { lhs = '<Leader>g', mode = 'n', rhs = function() Snacks.picker.grep({ hidden = true }) end })
K('Grep Word', { lhs = '<Leader>G', mode = { 'n', 'x' }, rhs = function() Snacks.picker.grep_word() end })
K('Help', { lhs = '<Leader>h', mode = 'n', rhs = function() Snacks.picker.help() end })
K('Lines', { lhs = '<Leader>/', mode = 'n', rhs = function() Snacks.picker.lines() end })
K('Resume', { lhs = '<Leader>c', mode = 'n', rhs = function() Snacks.picker.resume() end })
K('Pickers', { lhs = '<Leader>p', mode = 'n', rhs = function() Snacks.picker.pickers() end })

K('Actions', { lhs = 'ga', mode = 'n', rhs = function() vim.lsp.buf.code_action() end })
K('Rename', { lhs = 'gn', mode = 'n', rhs = function() vim.lsp.buf.rename() end })
K('Symbols', { lhs = 'gs', mode = 'n', rhs = function() Snacks.picker.lsp_symbols() end })
K('Symbols (Project)', { lhs = 'gS', mode = 'n', rhs = function() Snacks.picker.lsp_workspace_symbols() end })
K('Diagnostics', { lhs = 'gD', mode = 'n', rhs = function() Snacks.picker.diagnostics() end })

K('Eval', { lhs = 'K', mode = 'n', rhs = function() vim.lsp.buf.hover({ border = 'rounded' }) end })
K('Eval Error', { lhs = 'E', mode = 'n', rhs = function() vim.diagnostic.open_float({ border = 'rounded' }) end })
K('Help', { lhs = '<C-k>', mode = 'i', rhs = function() vim.lsp.buf.signature_help({ border = 'rounded' }) end })

K('Definition', { lhs = 'gd', mode = 'n', rhs = _G.LSP('definitions') })
K('Impl', { lhs = 'gi', mode = 'n', rhs = _G.LSP('implementations') })
K('References', { lhs = 'gr', mode = 'n', nowait = true, rhs = _G.LSP('references') })
K('Typedefs', { lhs = 'gy', mode = 'n', rhs = _G.LSP('type_definitions') })

K('REPL', { lhs = '<Leader>dR', mode = 'n', rhs = function() require('dap.repl').toggle({}, 'belowright split') end })
K('Breakpoint', { lhs = '<Leader>db', mode = 'n', rhs = function() require('dap').toggle_breakpoint() end })
K('Clear breakpoints', { lhs = '<Leader>dc', mode = 'n', rhs = function() require('dap').clear_breakpoints() end })
K('Eval', { lhs = '<Leader>de', mode = { 'n', 'x' }, rhs = function() require('dap.ui.widgets').hover() end })
K('Run', { lhs = '<Leader>dr', mode = 'n', rhs = function() require('dap').continue() end })
K('Quit', { lhs = '<Leader>dq', mode = 'n', rhs = function() require('dap').terminate() end })

K('Scopes', { lhs = '<Leader>ds', mode = 'n', rhs = _G.Scopes })
