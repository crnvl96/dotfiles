vim.keymap.set('x', 'p', 'P', { noremap = true })
vim.keymap.set('n', 'Y', 'v$<left>y', { desc = 'Copy till end of line' })

vim.keymap.set({ 'n', 'x', 'i' }, '<c-s>', '<esc><cmd>w<cr><esc>')
vim.keymap.set({ 'i', 'x', 'n' }, '<esc>', '<esc><cmd>noh<cr><esc>')

vim.keymap.set('n', '<c-d>', '<c-d>zz', { desc = 'Scroll downwards' })
vim.keymap.set('n', '<c-u>', '<c-u>zz', { desc = 'Scroll upwards' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next result' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous result' })
vim.keymap.set('n', '*', '*zzzv', { desc = 'Previous result' })
vim.keymap.set('n', '#', '#zzzv', { desc = 'Previous result' })

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('n', '<c-up>', '<cmd>resize +5<cr>')
vim.keymap.set('n', '<c-down>', '<cmd>resize -5<cr>')
vim.keymap.set('n', '<c-left>', '<cmd>vertical resize -20<cr>')
vim.keymap.set('n', '<c-right>', '<cmd>vertical resize +20<cr>')
vim.keymap.set('n', '<c-w>+', '<cmd>resize +5<cr>')
vim.keymap.set('n', '<c-w>-', '<cmd>resize -5<cr>')
vim.keymap.set('n', '<c-w><', '<cmd>vertical resize -20<cr>')
vim.keymap.set('n', '<c-w>>', '<cmd>vertical resize +20<cr>')

vim.keymap.set('n', '-', '<cmd>Ex<cr>')

vim.keymap.set({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })
