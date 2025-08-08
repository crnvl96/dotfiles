MiniDeps.later(function()
  MiniDeps.add('nvzone/volt')
  MiniDeps.add('nvzone/floaterm')

  require('floaterm').setup({
    border = true,
    size = { h = 95, w = 95 },
    mappings = { sidebar = nil, term = nil },
    terminals = { { name = 'Terminal' } },
  })

  vim.keymap.set('n', '<C-t>', '<Cmd>FloatermToggle<CR>')
  vim.keymap.set('t', '<C-t>', '<Cmd>FloatermToggle<CR>')
end)
