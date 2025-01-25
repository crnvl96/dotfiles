-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n

Utils.Keymap('Scroll down', {
  lhs = '<C-d>',
  rhs = '<C-d>zz',
})

Utils.Keymap('Scroll up', {
  lhs = '<C-u>',
  rhs = '<C-u>zz',
})

Utils.Keymap('Search current word forward', {
  lhs = '*',
  rhs = '*zzzv',
})

Utils.Keymap('Search current word backward', {
  lhs = '#',
  rhs = '#zzzv',
})

Utils.Keymap('Search forward', {
  expr = true,
  lhs = 'n',
  rhs = "'Nn'[v:searchforward].'zzzv'",
})

Utils.Keymap('Search backward', {
  expr = true,
  lhs = 'N',
  rhs = "'nN'[v:searchforward].'zzzv'",
})

Utils.Keymap('Better paste', {
  mode = 'x',
  lhs = 'p',
  rhs = 'P',
})

Utils.Keymap('Move down', {
  mode = { 'n', 'x' },
  expr = true,
  lhs = 'j',
  rhs = [[v:count == 0 ? 'gj' : 'j']],
})

Utils.Keymap('Move up', {
  mode = { 'n', 'x' },
  expr = true,
  lhs = 'k',
  rhs = [[v:count == 0 ? 'gk' : 'k']],
})

Utils.Keymap('Clear highlight', {
  mode = { 'n', 'x', 'i' },
  lhs = '<Esc>',
  rhs = '<Esc><Cmd>nohl<CR><Esc>',
})

Utils.Keymap('Better Esc', {
  mode = { 'n', 'i', 'x', 'o', 't', 'c' },
  lhs = '<M-x>',
  rhs = function()
    local code_esc = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
    vim.api.nvim_feedkeys(code_esc, 'm', false)
  end,
})

Utils.Keymap('Better Up', {
  mode = { 'n', 'v' },
  lhs = 'K',
  rhs = '6k',
})

Utils.Keymap('Better Down', {
  mode = { 'n', 'v' },
  lhs = 'J',
  rhs = '6j',
})

Utils.Keymap('Start of the file', {
  mode = 'n',
  lhs = 'H',
  rhs = function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('_', true, true, true), 'm', false) end,
})

Utils.Keymap('End of the file', {
  mode = 'n',
  lhs = 'L',
  rhs = function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('$', true, true, true), 'm', false) end,
})

Utils.Keymap('Join lines', {
  mode = 'n',
  lhs = 'S',
  rhs = function() vim.cmd('join') end,
})

Utils.Keymap('Window left', {
  lhs = '<C-h>',
  rhs = '<C-w>h',
})

Utils.Keymap('Window down', {
  lhs = '<C-j>',
  rhs = '<C-w>j',
})

Utils.Keymap('Window up', {
  lhs = '<C-k>',
  rhs = '<C-w>k',
})

Utils.Keymap('Window right', {
  lhs = '<C-l>',
  rhs = '<C-w>l',
})

Utils.Keymap('Resize height +', {
  remap = true,
  lhs = '<C-w>+',
  rhs = '<Cmd>resize +5<CR>',
})

Utils.Keymap('Resize height -', {
  remap = true,
  lhs = '<C-w>-',
  rhs = '<Cmd>resize -5<CR>',
})

Utils.Keymap('Resize width -', {
  remap = true,
  lhs = '<C-w><',
  rhs = '<Cmd>vertical resize -20<CR>',
})

Utils.Keymap('Resize width +', {
  remap = true,
  lhs = '<C-w>>',
  rhs = '<Cmd>vertical resize +20<CR>',
})

Utils.Keymap('Resize height +', {
  remap = true,
  lhs = '<C-Up>',
  rhs = '<Cmd>resize +5<CR>',
})

Utils.Keymap('Resize height -', {
  remap = true,
  lhs = '<C-Down>',
  rhs = '<Cmd>resize -5<CR>',
})

Utils.Keymap('Resize width -', {
  remap = true,
  lhs = '<C-Left>',
  rhs = '<Cmd>vertical resize -20<CR>',
})

Utils.Keymap('Resize width +', {
  remap = true,
  lhs = '<C-Right>',
  rhs = '<Cmd>vertical resize +20<CR>',
})

Utils.Keymap('Save', {
  mode = { 'n', 'i', 'x' },
  lhs = '<C-s>',
  rhs = '<Esc><Cmd>w<CR><Esc>',
})

Utils.Keymap('Indent right', {
  mode = 'x',
  lhs = '>',
  rhs = '>gv',
})

Utils.Keymap('Indent left', {
  mode = 'x',
  lhs = '<',
  rhs = '<gv',
})
