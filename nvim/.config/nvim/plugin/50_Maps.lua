local function term_send_esc(key)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true)
      .. vim.api.nvim_replace_termcodes(key, true, true, true),
    't',
    true
  )
end

vim.keymap.set('x', 'p', 'P')
vim.keymap.set({ 'n', 'x' }, 'Y', 'yg_')
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>p', '"+p', { desc = 'Paste from clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>P', '"+P', { desc = 'Paste from clipboard before cursor' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>y', '"+y', { desc = 'Yank to clipboard' })
vim.keymap.set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_', { desc = 'Yank to clipboard till end of line' })
vim.keymap.set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set({ 'n', 'i', 'x' }, '<C-S>', '<Esc><Cmd>silent! update | redraw<CR>')
vim.keymap.set('x', '<', '<gv')
vim.keymap.set('x', '>', '>gv')
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-Down>', '<Cmd>resize -5<CR>')
vim.keymap.set('n', '<C-Up>', '<Cmd>resize +5<CR>')
vim.keymap.set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
vim.keymap.set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
vim.keymap.set('n', '=', 'mzgggqG`z<cmd>delmarks z<cr>zz')
vim.keymap.set('t', '<C-h>', function() term_send_esc('<C-h>') end, { noremap = true })
vim.keymap.set('t', '<C-j>', function() term_send_esc('<C-j>') end, { noremap = true })
vim.keymap.set('t', '<C-k>', function() term_send_esc('<C-k>') end, { noremap = true })
vim.keymap.set('t', '<C-l>', function() term_send_esc('<C-l>') end, { noremap = true })
