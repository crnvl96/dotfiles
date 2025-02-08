Add('folke/snacks.nvim')

require('snacks').setup({
  bigfile = { enabled = true },
  indent = {
    indent = { enabled = false },
    scope = { enabled = false },
    chunk = { enabled = true },
  },
  input = { enabled = true },
  notifier = { enabled = true },
  gitbrowse = {
    notify = true,
    open = function(url) vim.fn.setreg('+', url) end,
  },
  picker = {
    win = {
      input = {
        keys = {
          ['yy'] = 'copy',
          ['<m-y>'] = { 'copy', mode = { 'n', 'i' } },
        },
      },
      list = { keys = { ['yy'] = 'copy' } },
    },
  },
})

Utils.User('Browse', function() Snacks.gitbrowse() end, {})

local K = Utils.Keymap

K('Buffers', { lhs = '<Leader>b', mode = 'n', rhs = function() Snacks.picker.buffers() end })
K('Files', { lhs = '<Leader>f', mode = 'n', rhs = function() Snacks.picker.files({ hidden = true }) end })
K('Grep', { lhs = '<Leader>g', mode = 'n', rhs = function() Snacks.picker.grep({ hidden = true }) end })
K('Grep Word', { lhs = '<Leader>G', mode = { 'n', 'x' }, rhs = function() Snacks.picker.grep_word() end })
K('Help', { lhs = '<Leader>h', mode = 'n', rhs = function() Snacks.picker.help() end })
K('Keymaps', { lhs = '<Leader>k', mode = 'n', rhs = function() Snacks.picker.keymaps() end })
K('Lines', { lhs = '<Leader>/', mode = 'n', rhs = function() Snacks.picker.lines() end })
K('Resume', { lhs = '<Leader>c', mode = 'n', rhs = function() Snacks.picker.resume() end })
K('Pickers', { lhs = '<Leader>p', mode = 'n', rhs = function() Snacks.picker.pickers() end })

K('Actions', { lhs = 'ga', mode = 'n', rhs = function() vim.lsp.buf.code_action() end })
K('Rename', { lhs = 'gn', mode = 'n', rhs = function() vim.lsp.buf.rename() end })
K('Diagnostics', { lhs = 'gx', mode = 'n', rhs = function() Snacks.picker.diagnostics() end })
K('Eval', { lhs = 'K', mode = 'n', rhs = function() vim.lsp.buf.hover({ border = 'rounded' }) end })
K('Eval Error', { lhs = 'E', mode = 'n', rhs = function() vim.diagnostic.open_float({ border = 'rounded' }) end })
K('Help', { lhs = '<C-k>', mode = 'i', rhs = function() vim.lsp.buf.signature_help({ border = 'rounded' }) end })
K('Definition', { lhs = 'gd', mode = 'n', rhs = function() Snacks.picker.lsp_definitions() end })
K('Declarations', { lhs = 'gD', mode = 'n', rhs = function() Snacks.picker.lsp_declarations() end })
K('Impl', { lhs = 'gi', mode = 'n', rhs = function() Snacks.picker.lsp_implementations() end })
K('References', { lhs = 'gr', mode = 'n', nowait = true, rhs = function() Snacks.picker.lsp_references() end })
K('Typedefs', { lhs = 'gy', mode = 'n', rhs = function() Snacks.picker.type_definitions() end })
