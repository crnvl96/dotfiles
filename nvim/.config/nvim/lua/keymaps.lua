local cursorPreYank

local set = vim.keymap.set

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('crnvl96-save-cursor-pos-on-yank', {}),
  callback = function()
    if vim.v.event.operator == 'y' and cursorPreYank then vim.api.nvim_win_set_cursor(0, cursorPreYank) end
  end,
})

local function save_cursor_pos_on_pre_yank(cmd)
  return function()
    cursorPreYank = vim.api.nvim_win_get_cursor(0)
    return cmd
  end
end

set('x', 'p', 'P')
set('x', 'Y', 'yg_')

set({ 'n', 'x' }, 'y', save_cursor_pos_on_pre_yank('y'), { expr = true })
set('n', 'Y', save_cursor_pos_on_pre_yank('y$'), { expr = true })

set({ 'n', 'x', 'o' }, '<Leader>p', '"+p')
set({ 'n', 'x', 'o' }, '<Leader>P', '"+P')
set({ 'n', 'x', 'o' }, '<Leader>y', '"+y')
set({ 'n', 'x', 'o' }, '<Leader>Y', '"+yg_')

set({ 'n', 'x', 'i', 's' }, '<Esc>', '<Cmd>noh<CR><Esc>')
set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

set('n', '<C-Down>', '<Cmd>resize -5<CR>')
set('n', '<C-Left>', '<Cmd>vertical resize -20<CR>')
set('n', '<C-Right>', '<Cmd>vertical resize +20<CR>')
set({ 'i', 'n', 'x', 'o' }, '<C-s>', '<Esc><Cmd>noh<CR><Cmd>write<CR><Esc>')

set('x', '<', '<gv')
set('x', '>', '>gv')

set('n', '<C-h>', '<C-w>h')
set('n', '<C-j>', '<C-w>j')
set('n', '<C-k>', '<C-w>k')
set('n', '<C-l>', '<C-w>l')
