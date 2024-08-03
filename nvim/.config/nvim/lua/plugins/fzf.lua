MiniDeps.add({
  source = 'junegunn/fzf.vim',
  depends = {
    {
      source = 'junegunn/fzf',
      hooks = {
        post_checkout = function() vim.fn['fzf#install']() end,
      },
    },
  },
})

vim.g.fzf_vim = {}
vim.g.fzf_vim.preview_window = { 'hidden,right,50%,<70(up,40%)', 'f4' }
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }

vim.g.fzf_colors = {
  ['fg'] = { 'fg', 'Normal' },
  ['bg'] = { 'bg', 'Normal' },
  ['hl'] = { 'fg', 'Comment' },
  ['fg+'] = { 'fg', 'CursorLine', 'CursorColumn', 'Normal' },
  ['bg+'] = { 'bg', 'CursorLine', 'CursorColumn' },
  ['hl+'] = { 'fg', 'Statement' },
  ['info'] = { 'fg', 'PreProc' },
  ['border'] = { 'fg', 'Ignore' },
  ['prompt'] = { 'fg', 'Conditional' },
  ['pointer'] = { 'fg', 'Exception' },
  ['marker'] = { 'fg', 'Keyword' },
  ['spinner'] = { 'fg', 'Label' },
  ['header'] = { 'fg', 'Comment' },
}

vim.keymap.set('n', '<leader>ff', '<cmd>Files<CR>', { desc = 'Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Rg<CR>', { desc = 'Grep' })
