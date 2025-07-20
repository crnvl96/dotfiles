vim.keymap.set('x', 'p', 'P')
vim.keymap.set('x', 'Y', 'yg_')

vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p', { desc = 'Paste from Clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P', { desc = 'Paste fro Clipboard (before cursor)' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y', { desc = 'Copy to Clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_', { desc = 'Copy line to Clipboard' })

vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')

vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
