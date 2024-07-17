require('mini.extra').setup()
require('mini.visits').setup()

require('mini.pick').setup({
  options = {
    use_cache = true,
  },
})

vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', { desc = 'Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>Pick grep_live<cr>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>fo', '<cmd>Pick oldfiles<cr>', { desc = 'Oldfiles' })
vim.keymap.set('n', '<leader>fm', '<cmd>Pick marks<cr>', { desc = 'Marks' })
