local set = vim.keymap.set

set('x', 'p', 'P')
set('x', 'Y', 'yg_')

set('n', '<C-t>', function()
  vim.cmd('tabnext')
  vim.cmd('startinsert')
end)

set('t', '<C-t>', '<C-\\><C-n><Cmd>tabnext<CR>')

set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
set({ 'n', 'x', 'o' }, '<Leader>P', '"+P')
set({ 'n', 'x', 'o' }, '<Leader>y', '"+y')
set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_')

set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')
set('n', 'n', 'nzzzv')
set('n', 'N', 'Nzzzv')

set('n', '=', 'mzgggqG`z<cmd>delmarks z<cr>zz')

set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

set('n', '<C-Down>', '<Cmd>resize -5<CR>')
set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')

set({ 'i', 'n', 'x', 'o' }, '<C-s>', '<Esc>:noh<CR>:w<CR><Esc>')

set('x', '<', '<gv')
set('x', '>', '>gv')

set('n', '<C-h>', '<C-w>h')
set('n', '<C-j>', '<C-w>j')
set('n', '<C-k>', '<C-w>k')
set('n', '<C-l>', '<C-w>l')
