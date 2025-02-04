local K = Utils.Keymap

Add('theHamsta/nvim-dap-virtual-text')
Add('mfussenegger/nvim-dap-python')
Add('mfussenegger/nvim-dap')
Add('igorlfs/nvim-dap-view')

require('dap-view').setup()
require('nvim-dap-virtual-text').setup({ virt_text_pos = 'eol' })
require('dap-python').setup('uv')
require('mini.snippets').setup({ snippets = { require('mini.snippets').gen_loader.from_lang() } })

require('dap.ext.vscode').json_decode = function(data)
  local decode = vim.json.decode
  local strip_comments = require('plenary.json').json_strip_comments
  data = strip_comments(data)
  return decode(data)
end

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
