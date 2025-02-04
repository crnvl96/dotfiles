Add('folke/snacks.nvim')

local K = Utils.Keymap

require('snacks').setup({
  bigfile = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  explorer = {
    replace_netrw = true,
  },
  gitbrowse = {
    notify = false,
    open = function(url) vim.fn.setreg('+', url) end,
  },
  picker = {
    icons = {
      files = {
        enabled = false,
      },
    },
    formatters = {
      file = {
        filename_first = true,
      },
    },
    sources = {
      explorer = {},
    },
    win = {
      input = {
        keys = {
          ['yy'] = 'copy',
          ['<c-y>'] = { 'copy', mode = { 'n', 'i' } },
        },
      },
      list = { keys = { ['yy'] = 'copy' } },
    },
  },
})

vim.print = function(...) require('snacks').debug.inspect(...) end

local T = Snacks.toggle
vim.g.autoformat = false

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

K('Last', { lhs = '<Leader>bl', mode = 'n', rhs = '<Cmd>b#<CR>' })
K('Delete', { lhs = '<Leader>bd', mode = 'n', rhs = function() Snacks.bufdelete.bufdelete() end })
K('Others', { lhs = '<Leader>bo', mode = 'n', rhs = function() Snacks.bufdelete.other() end })

K('Explorer', {
  lhs = '<Leader>e',
  mode = 'n',
  rhs = function()
    Snacks.picker.explorer({
      auto_close = true,
      jump = { close = true },
      layout = { preset = 'ivy', preview = true },
    })
  end,
})

K('Buffers', { lhs = '<Leader>fb', mode = 'n', rhs = function() Snacks.picker.buffers() end })
K('Files', { lhs = '<Leader>ff', mode = 'n', rhs = function() Snacks.picker.files({ hidden = true }) end })
K('Grep', { lhs = '<Leader>fg', mode = 'n', rhs = function() Snacks.picker.grep({ hidden = true }) end })
K('Grep', { lhs = '<Leader>sg', mode = { 'n', 'x' }, rhs = function() Snacks.picker.grep_word() end })
K('Help', { lhs = '<Leader>fh', mode = 'n', rhs = function() Snacks.picker.help() end })
K('Lines', { lhs = '<Leader>fl', mode = 'n', rhs = function() Snacks.picker.lines() end })
K('Oldfiles', { lhs = '<Leader>fo', mode = 'n', rhs = function() Snacks.picker.recent() end })
K('Resume', { lhs = '<Leader>fr', mode = 'n', rhs = function() Snacks.picker.resume() end })
K('Pickers', { lhs = '<Leader>fp', mode = 'n', rhs = function() Snacks.picker.pickers() end })

K('Blame', { lhs = '<Leader>gb', mode = 'n', rhs = function() Snacks.git.blame_line() end })
K('Browse', { lhs = '<Leader>gB', mode = { 'n', 'v' }, rhs = function() Snacks.gitbrowse() end })

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

K('History', { lhs = '<Leader>nh', mode = 'n', rhs = function() Snacks.notifier.show_history() end })
K('Clear', { lhs = '<Leader>nc', mode = 'n', rhs = function() Snacks.notifier.hide() end })
