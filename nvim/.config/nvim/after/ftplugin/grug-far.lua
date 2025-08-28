vim.keymap.set('n', '<C-enter>', function()
  require('grug-far').get_instance(0):open_location()
  require('grug-far').get_instance(0):close()
end, { buffer = true, desc = 'Go to entry and close grug-far' })
