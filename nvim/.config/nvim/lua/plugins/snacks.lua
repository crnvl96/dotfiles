require('snacks').setup({
  terminal = {
    win = {
      border = 'single',
    },
  },
  styles = {
    terminal = {
      height = 0.95,
      width = 0.95,
    },
    lazygit = {
      height = 0.95,
      width = 0.95,
    },
  },
})

vim.keymap.set('n', '<Leader>z', function() Snacks.terminal() end, { desc = 'Terminal' })
vim.keymap.set('n', '<Leader>x', function() Snacks.terminal('opencode') end, { desc = 'Opencode' })
vim.keymap.set('n', '<Leader>v', function() Snacks.lazygit() end, { desc = 'Lazygit' })
