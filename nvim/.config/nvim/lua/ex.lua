MiniDeps.add('stevearc/oil.nvim')

require('oil').setup({
  columns = { 'icon' },
  watch_for_changes = true,
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.select',
    ['<C-s>'] = false,
    ['<M-v>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
    ['<C-h>'] = false,
    ['<M-s>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
    ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
    ['<C-p>'] = 'actions.preview',
    ['<C-c>'] = 'actions.close',
    ['<C-l>'] = false,
    ['<M-l>'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['`'] = 'actions.cd',
    ['~'] = { 'actions.cd', opts = { scope = 'tab' }, desc = ':tcd to the current oil directory' },
    ['gs'] = 'actions.change_sort',
    ['gx'] = 'actions.open_external',
    ['g.'] = 'actions.toggle_hidden',
    ['g\\'] = false,
    ['<g/>'] = 'actions.toggle_trash',
  },
  view_options = { show_hidden = true },
  float = { border = 'none' },
  preview = { border = 'none' },
  progress = { border = 'none' },
  ssh = { border = 'none' },
  keymaps_help = { border = 'none' },
})

vim.keymap.set('n', '-', '<cmd>Oil<CR>')
