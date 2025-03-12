for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
    local lhs = '<C-' .. key .. '>'
    vim.keymap.set({ 'n', 'v', 'i' }, lhs, '<Esc><C-w><C-' .. key .. '>')
end

vim.keymap.set('', '<M-x>', ':')
vim.keymap.set('i', '<C-n>', '<C-x><C-o>')

vim.keymap.set('n', 'gy', ":<C-U>let @+ = expand('%:.')<CR>", { desc = 'Copy file name to default register' })
vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select pasted text' })

vim.keymap.set({ 'n', 'x' }, 'm', Utils.Marks.set_mark_swapped)
vim.keymap.set({ 'n', 'x' }, '<M-O>', Utils.Marks.goto_mark_swapped_quote)
vim.keymap.set({ 'n', 'x' }, '<M-o>', Utils.Marks.goto_mark_swapped_backtick)

vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<C-x>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>w<CR><Esc>')

vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

vim.keymap.set('n', '#', '#zzzv')
vim.keymap.set('n', '*', '*zzzv')
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-w>+', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-w>-', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-w><', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>')

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set('n', 'N', "'nN'[v:searchforward].'zzzv'", { expr = true })
vim.keymap.set('n', 'n', "'Nn'[v:searchforward].'zzzv'", { expr = true })
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')
vim.keymap.set('x', 'p', 'P')
