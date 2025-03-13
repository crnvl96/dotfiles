local set = vim.keymap.set

for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
    local lhs = '<C-' .. key .. '>'
    set({ 'n', 'v', 'i' }, lhs, '<Esc><C-w><C-' .. key .. '>')
end

set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
set({ 'n', 'x', 'o' }, '<Leader>y', '"+y')

set('', '<M-x>', ':')
set('i', '<C-n>', '<C-x><C-o>')

set('n', 'gy', ":<C-U>let @+ = expand('%:.')<CR>", { desc = 'Copy file name to default register' })
set('n', 'gp', '`[v`]', { desc = 'Select pasted text' })

set({ 'n', 'x' }, 'm', Utils.Marks.set_mark_swapped, { noremap = false })
set({ 'n', 'x' }, "'", Utils.Marks.goto_mark_swapped_quote, { noremap = false })
set({ 'n', 'x' }, '`', Utils.Marks.goto_mark_swapped_backtick, { noremap = false })

set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
set({ 'n', 'x', 'i', 's' }, '<C-x>', '<Cmd>noh<CR><Esc>')
set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w<CR><Esc>')

set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

set('n', '#', '#zzzv')
set('n', '*', '*zzzv')
set('n', '<C-Down>', '<Cmd>resize -5<CR>')
set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
set('n', '<C-Up>', '<Cmd>resize +5<CR>')
set('n', '<C-d>', '<C-d>zz')
set('n', '<C-u>', '<C-u>zz')
set('n', '<C-w>+', '<Cmd>resize +5<CR>')
set('n', '<C-w>-', '<Cmd>resize -5<CR>')
set('n', '<C-w><', '<Cmd>vertical resize -20<CR>')
set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>')

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set('n', 'N', "'nN'[v:searchforward].'zzzv'", { expr = true })
set('n', 'n', "'Nn'[v:searchforward].'zzzv'", { expr = true })

set('x', '<', '<gv')
set('x', '>', '>gv')
set('x', 'p', 'P')
