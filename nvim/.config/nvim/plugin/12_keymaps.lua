local set = vim.keymap.set

for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
    local lhs = '<C-' .. key .. '>'
    set({ 'n', 'x' }, lhs, '<Esc><C-w><C-' .. key .. '>')
end

set('x', 'p', 'P')

set({ 'n', 'x', 'o' }, '<Leader>p', '"+p', { desc = 'Paste from clipboard' })
set({ 'n', 'x', 'o' }, '<Leader>P', '"+P', { desc = 'Paste from clipboard' })
set({ 'n', 'x', 'o' }, '<Leader>y', '"+y', { desc = 'Copy to clipboard' })
set({ 'n', 'x', 'o' }, '<Leader>Y', '"+y$', { desc = 'Copy to clipboard' })

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

set('n', '<C-Down>', '<Cmd>resize -5<CR>')
set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
set('n', '<C-Up>', '<Cmd>resize +5<CR>')

set('n', '<C-w>+', '<Cmd>resize +5<CR>')
set('n', '<C-w>-', '<Cmd>resize -5<CR>')
set('n', '<C-w><', '<Cmd>vertical resize -20<CR>')
set('n', '<C-w>>', '<Cmd>vertical resize +20<CR>')

set('x', '<', '<gv')
set('x', '>', '>gv')
