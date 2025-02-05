-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n

local K = Utils.Keymap

for _, key in ipairs({ 'h', 'j', 'k', 'l' }) do
  K('Window ' .. string.upper(key), {
    mode = { 'n', 'v' },
    lhs = '<C-' .. key .. '>',
    rhs = function()
      local mode = vim.api.nvim_get_mode().mode

      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>', true, false, true), 't', true)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 't', true)

      if vim.startswith(string.lower(mode), 'v') then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
      end
    end,
    expr = true,
  })
end

K('Better paste', { mode = 'x', lhs = 'p', rhs = 'P' })
K('Scroll down', { lhs = '<C-d>', rhs = '<C-d>zz' })
K('Scroll up', { lhs = '<C-u>', rhs = '<C-u>zz' })
K('Search current word forward', { lhs = '*', rhs = '*zzzv' })
K('Search current word backward', { lhs = '#', rhs = '#zzzv' })
K('Search forward', { expr = true, lhs = 'n', rhs = "'Nn'[v:searchforward].'zzzv'" })
K('Search backward', { expr = true, lhs = 'N', rhs = "'nN'[v:searchforward].'zzzv'" })
K('Move down', { mode = { 'n', 'x' }, expr = true, lhs = 'j', rhs = [[v:count == 0 ? 'gj' : 'j']] })
K('Move up', { mode = { 'n', 'x' }, expr = true, lhs = 'k', rhs = [[v:count == 0 ? 'gk' : 'k']] })
K('Resize height +', { remap = true, lhs = '<C-w>+', rhs = '<Cmd>resize +5<CR>' })
K('Resize height -', { remap = true, lhs = '<C-w>-', rhs = '<Cmd>resize -5<CR>' })
K('Resize width -', { remap = true, lhs = '<C-w><', rhs = '<Cmd>vertical resize -20<CR>' })
K('Resize width +', { remap = true, lhs = '<C-w>>', rhs = '<Cmd>vertical resize +20<CR>' })
K('Resize height +', { remap = true, lhs = '<C-Up>', rhs = '<Cmd>resize +5<CR>' })
K('Resize height -', { remap = true, lhs = '<C-Down>', rhs = '<Cmd>resize -5<CR>' })
K('Resize width -', { remap = true, lhs = '<C-Left>', rhs = '<Cmd>vertical resize -20<CR>' })
K('Resize width +', { remap = true, lhs = '<C-Right>', rhs = '<Cmd>vertical resize +20<CR>' })
K('Save', { mode = { 'n', 'i', 'x' }, lhs = '<C-s>', rhs = '<Esc><Cmd>noh<CR><Cmd>w<CR><Esc>' })
K('Indent right', { mode = 'x', lhs = '>', rhs = '>gv' })
K('Indent left', { mode = 'x', lhs = '<', rhs = '<gv' })

K('Clear highlight', {
  mode = { 'n', 'x', 'i', 's' },
  expr = true,
  lhs = '<Esc>',
  rhs = function()
    vim.cmd('noh')
    return '<esc>'
  end,
})
