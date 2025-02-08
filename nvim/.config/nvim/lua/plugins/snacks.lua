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

vim.api.nvim_create_user_command('Browse', function() Snacks.gitbrowse() end, {})

vim.keymap.set('n', '<Leader>b', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<Leader>f', function() Snacks.picker.files({ hidden = true }) end, { desc = 'Files' })
vim.keymap.set('n', '<Leader>g', function() Snacks.picker.grep({ hidden = true }) end, { desc = 'Grep' })
vim.keymap.set({ 'n', 'x' }, '<Leader>G', function() Snacks.picker.grep_word() end, { desc = 'Grep Word' })
vim.keymap.set('n', '<Leader>h', function() Snacks.picker.help() end, { desc = 'Help' })
vim.keymap.set('n', '<Leader>k', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<Leader>/', function() Snacks.picker.lines() end, { desc = 'Lines' })
vim.keymap.set('n', '<Leader>c', function() Snacks.picker.resume() end, { desc = 'Resume' })
vim.keymap.set('n', '<Leader>p', function() Snacks.picker.pickers() end, { desc = 'Pickers' })

vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Actions' })
vim.keymap.set('n', 'gn', function() vim.lsp.buf.rename() end, { desc = 'Rename' })
vim.keymap.set('n', 'gx', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { desc = 'Eval' })
vim.keymap.set('n', 'E', function() vim.diagnostic.open_float({ border = 'rounded' }) end, { desc = 'Eval Error' })
vim.keymap.set('i', '<C-k>', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end, { desc = 'Help' })
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Definition' })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Declarations' })
vim.keymap.set('n', 'gi', function() Snacks.picker.lsp_implementations() end, { desc = 'Impl' })
vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references() end, { desc = 'References', nowait = true })
vim.keymap.set('n', 'gy', function() Snacks.picker.type_definitions() end, { desc = 'Typedefs' })
