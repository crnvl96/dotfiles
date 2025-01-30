---
--- Toggling features
---

local T = Snacks.toggle
vim.g.autoformat = true

local function set_autoformat(e)
  if e then
    vim.g.autoformat = true
  else
    vim.g.autoformat = false
  end
end

local wrap = T.option('wrap')
local relnum = T.option('relativenumber')
local autofmt = T({ name = 'Auto format', get = function() return vim.g.autoformat end, set = set_autoformat })

wrap:map('<leader>uw', { desc = 'Wrap' })
relnum:map('<leader>ur', { desc = 'Relnum' })
autofmt:map('<Leader>ua', { desc = 'Autoformat' })

---
--- [B]uffers keymaps
---

local K = Utils.Keymap

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

local function dap_open_scopes()
  local widgets = require('dap.ui.widgets')
  widgets.sidebar(widgets.scopes, {}, 'vsplit').toggle()
end

K('REPL', { lhs = '<Leader>dR', mode = 'n', rhs = function() require('dap.repl').toggle({}, 'belowright split') end })
K('Breakpoint', { lhs = '<Leader>db', mode = 'n', rhs = function() require('dap').toggle_breakpoint() end })
K('Clear breakpoints', { lhs = '<Leader>dc', mode = 'n', rhs = function() require('dap').clear_breakpoints() end })
K('Eval', { lhs = '<Leader>de', mode = { 'n', 'x' }, rhs = function() require('dap.ui.widgets').hover() end })
K('Run', { lhs = '<Leader>dr', mode = 'n', rhs = function() require('dap').continue() end })
K('Quit', { lhs = '<Leader>dq', mode = 'n', rhs = function() require('dap').terminate() end })
K('Scopes', { lhs = '<Leader>ds', mode = 'n', rhs = dap_open_scopes })

---
--- [E]xplorer keymaps
---

K('Explorer', {
  lhs = '<Leader>e',
  mode = 'n',
  rhs = function()
    Snacks.picker.explorer({
      git_status_open = true,
      auto_close = true,
      jump = { close = true },
    })
  end,
})

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
local lsp_opts = {
  include_current = true,
  auto_confirm = false,
  jump = { reuse_win = false },
}

K('Actions', { lhs = '<Leader>la', mode = 'n', rhs = function() vim.lsp.buf.code_action() end })
K('Eval', { lhs = 'K', mode = 'n', rhs = function() vim.lsp.buf.hover({ border = 'rounded' }) end })
K('Help', { lhs = '<Leader>lh', mode = 'n', rhs = function() vim.lsp.buf.signature_help({ border = 'rounded' }) end })
K('Eval Error', { lhs = 'E', mode = 'n', rhs = function() vim.diagnostic.open_float({ border = 'rounded' }) end })
K('Rename', { lhs = '<Leader>lR', mode = 'n', rhs = function() vim.lsp.buf.rename() end })
K('Definition', { lhs = '<Leader>ld', mode = 'n', rhs = function() Snacks.picker.lsp_definitions(lsp_opts) end })
K('Impl', { lhs = '<Leader>li', mode = 'n', rhs = function() Snacks.picker.lsp_implementations(lsp_opts) end })
K('References', { lhs = '<Leader>lr', mode = 'n', rhs = function() Snacks.picker.lsp_references(lsp_opts) end })
K('Symbols', { lhs = '<Leader>ls', mode = 'n', rhs = function() Snacks.picker.lsp_symbols() end })
K('Symbols (Project)', { lhs = '<Leader>lS', mode = 'n', rhs = function() Snacks.picker.lsp_workspace_symbols() end })
K('Diagnostics', { lhs = '<Leader>lD', mode = 'n', rhs = function() Snacks.picker.diagnostics() end })
K('Typedefs', { lhs = '<Leader>lt', mode = 'n', rhs = function() Snacks.picker.lsp_type_definitions(lsp_opts) end })

---
--- [N]otifications keymaps
---

K('History', { lhs = '<Leader>nh', mode = 'n', rhs = function() Snacks.notifier.show_history() end })
K('Clear', { lhs = '<Leader>nc', mode = 'n', rhs = function() Snacks.notifier.hide() end })
