MiniDeps.add('folke/snacks.nvim')

require('snacks').setup({
  terminal = { win = { border = 'single' } },
  styles = {
    terminal = { height = 0.95, width = 0.95 },
    lazygit = { height = 0.95, width = 0.95 },
  },
})

vim.keymap.set({ 'n', 't' }, '<C-t>', function() Snacks.terminal() end, { desc = 'Terminal' })
vim.keymap.set({ 'n', 't' }, '<C-a>', function() Snacks.terminal('opencode') end, { desc = 'Terminal' })

if vim.fn.executable('lazygit') == 1 then
  vim.keymap.set('n', '<leader>s', function() Snacks.lazygit() end, { desc = 'Lazygit' })
end
