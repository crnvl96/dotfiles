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
