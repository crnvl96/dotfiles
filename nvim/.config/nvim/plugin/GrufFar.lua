MiniDeps.add('MagicDuck/grug-far.nvim')

require('grug-far').setup({
  transient = true,
})

vim.keymap.set(
  'n',
  '<Leader>g',
  function()
    require('grug-far').toggle_instance({
      instanceName = 'far',
      staticTitle = 'Find and Replace',
    })
  end,
  { desc = 'Live grep' }
)

vim.keymap.set(
  'n',
  '<Leader>l',
  function()
    require('grug-far').toggle_instance({
      instanceName = 'far',
      staticTitle = 'Find and Replace',
      prefills = { paths = vim.fn.expand('%') },
    })
  end,
  { desc = 'Buffer lines' }
)
