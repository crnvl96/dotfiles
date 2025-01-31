---
--- Toggling features
---

Snacks.toggle.option('wrap'):map('<leader>uw', { desc = 'Wrap' })
Snacks.toggle.option('relativenumber'):map('<leader>ur', { desc = 'Relnum' })

vim.g.autoformat = true

Snacks.toggle({
  name = 'Auto format',
  get = function() return vim.g.autoformat end,
  set = function(e)
    if e then
      vim.g.autoformat = true
    else
      vim.g.autoformat = false
    end
  end,
}):map('<Leader>ua', { desc = 'Autoformat' })

---
--- Window features
---
local K = Utils.Keymap

K('Window left', { lhs = '<C-h>', rhs = '<Cmd>TmuxNavigateLeft<CR>' })
K('Window down', { lhs = '<C-j>', rhs = '<Cmd>TmuxNavigateDown<CR>' })
K('Window up', { lhs = '<C-k>', rhs = '<Cmd>TmuxNavigateUp<CR>' })
K('Window right', { lhs = '<C-l>', rhs = '<Cmd>TmuxNavigateRight<CR>' })

---
--- [B]uffers keymaps
---

K('Last', { lhs = '<Leader>bl', mode = 'n', rhs = '<Cmd>b#<CR>' })
K('Delete', { lhs = '<Leader>bd', mode = 'n', rhs = function() Snacks.bufdelete.bufdelete() end })
K('Others', { lhs = '<Leader>bo', mode = 'n', rhs = function() Snacks.bufdelete.other() end })

---
--- AI [C]oding keymaps
---

K('Actions', { lhs = '<Leader>ca', mode = { 'n', 'v' }, rhs = '<Cmd>CodeCompanionActions<CR>' })
K('Toggle', { lhs = '<Leader>ct', mode = { 'n', 'v' }, rhs = '<Cmd>CodeCompanionChat Toggle<CR>' })
K('Chat', { lhs = '<Leader>cc', mode = 'v', rhs = ':CodeCompanionChat Add<CR>' })

---
--- [D]AP Keymaps
---

K('REPL', { lhs = '<Leader>dR', mode = 'n', rhs = function() require('dap.repl').toggle({}, 'belowright split') end })
K('Breakpoint', { lhs = '<Leader>db', mode = 'n', rhs = function() require('dap').toggle_breakpoint() end })
K('Clear breakpoints', { lhs = '<Leader>dc', mode = 'n', rhs = function() require('dap').clear_breakpoints() end })
K('Eval', { lhs = '<Leader>de', mode = { 'n', 'x' }, rhs = function() require('dap.ui.widgets').hover() end })
K('Run', { lhs = '<Leader>dr', mode = 'n', rhs = function() require('dap').continue() end })
K('Quit', { lhs = '<Leader>dq', mode = 'n', rhs = function() require('dap').terminate() end })

Utils.Keymap('Scopes', {
  lhs = '<Leader>ds',
  mode = 'n',
  rhs = function()
    local dap_widgets = require('dap.ui.widgets')
    dap_widgets.sidebar(dap_widgets.scopes, {}, 'vsplit').toggle()
  end,
})

---
--- [E]xplorer keymaps
---

K('Oil', { lhs = '<Leader>e', mode = 'n', rhs = '<Cmd>Oil<CR>' })

---
--- [F]ind keymaps
---

K('Buffers', { lhs = '<Leader>fb', mode = 'n', rhs = function() Snacks.picker.buffers() end })
K('Files', { lhs = '<Leader>ff', mode = 'n', rhs = function() Snacks.picker.files({ hidden = true }) end })
K('Grep', { lhs = '<Leader>fg', mode = 'n', rhs = function() Snacks.picker.grep({ hidden = true }) end })
K('Grep', { lhs = '<Leader>sg', mode = { 'n', 'x' }, rhs = function() Snacks.picker.grep_word() end })
K('Help', { lhs = '<Leader>fh', mode = 'n', rhs = function() Snacks.picker.help() end })
K('Lines', { lhs = '<Leader>fl', mode = 'n', rhs = function() Snacks.picker.lines() end })
K('Oldfiles', { lhs = '<Leader>fo', mode = 'n', rhs = function() Snacks.picker.recent() end })
K('Resume', { lhs = '<Leader>fr', mode = 'n', rhs = function() Snacks.picker.resume() end })
K('Pickers', { lhs = '<Leader>fp', mode = 'n', rhs = function() Snacks.picker.pickers() end })

---
--- [G]it keymaps
---

K('Blame', { lhs = '<Leader>gb', mode = 'n', rhs = function() Snacks.git.blame_line() end })
K('Browse', { lhs = '<Leader>gB', mode = { 'n', 'v' }, rhs = function() Snacks.gitbrowse() end })

---
--- [L]sp keymaps
---

K('Actions', { lhs = '<Leader>la', mode = 'n', rhs = function() vim.lsp.buf.code_action() end })

Utils.Keymap('Eval', {
  lhs = 'K',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.hover({ border = 'rounded' })
  end,
})

Utils.Keymap('Help', {
  lhs = '<Leader>lh',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.signature_help({ border = 'rounded' })
  end,
})

Utils.Keymap('Eval Error', {
  lhs = 'E',
  mode = 'n',
  rhs = function()
    local diagnostic = vim.diagnostic
    diagnostic.open_float({ border = 'rounded' })
  end,
})

Utils.Keymap('Rename', {
  lhs = '<Leader>lR',
  mode = 'n',
  rhs = function()
    local lsp = vim.lsp.buf
    lsp.rename()
  end,
})

Utils.Keymap('Definition', {
  lhs = '<Leader>ld',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_definitions({
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end,
})

Utils.Keymap('Implementation', {
  lhs = '<Leader>li',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_implementations({
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end,
})

Utils.Keymap('References', {
  lhs = '<Leader>lr',
  mode = 'n',
  nowait = true,
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_references({
      include_declaration = true,
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end,
})

Utils.Keymap('Symbols', {
  lhs = '<Leader>ls',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_symbols()
  end,
})

Utils.Keymap('Symbols (Project)', {
  lhs = '<Leader>lS',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_workspace_symbols()
  end,
})

Utils.Keymap('Diagnostics', {
  lhs = '<Leader>lD',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.diagnostics()
  end,
})

Utils.Keymap('Type definition', {
  lhs = '<Leader>lt',
  mode = 'n',
  rhs = function()
    local picker = Snacks.picker
    picker.lsp_type_definitions({
      include_current = true,
      auto_confirm = false,
      jump = { reuse_win = false },
    })
  end,
})

---
--- [N]otifications keymaps
---

Utils.Keymap('History', {
  lhs = '<Leader>nh',
  mode = 'n',
  rhs = function()
    local notifier = Snacks.notifier
    notifier.show_history()
  end,
})

Utils.Keymap('Clear', {
  lhs = '<Leader>nc',
  mode = 'n',
  rhs = function()
    local notifier = Snacks.notifier
    notifier.hide()
  end,
})
