local set = vim.keymap.set

set('x', 'p', 'P')

set({ 'n', 'x' }, 'Y', 'yg_')

set({ 'n', 'x', 'o' }, '<Leader>p', '"+p', { desc = 'Paste from clipboard' })
set({ 'n', 'x', 'o' }, '<Leader>P', '"+P', { desc = 'Paste from clipboard before cursor' })
set({ 'n', 'x', 'o' }, '<Leader>y', '"+y', { desc = 'Yank to clipboard' })
set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_', { desc = 'Yank to clipboard till end of line' })

set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

set('n', '<C-Down>', '<Cmd>resize -5<CR>')
set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
set({ 'n', 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>')

set('x', '<', '<gv')
set('x', '>', '>gv')

set('n', '<C-h>', '<C-w>h')
set('n', '<C-j>', '<C-w>j')
set('n', '<C-k>', '<C-w>k')
set('n', '<C-l>', '<C-w>l')
