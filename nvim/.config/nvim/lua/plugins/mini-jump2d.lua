MiniDeps.later(function()
  local jump2d = require('mini.jump2d')

  jump2d.setup({
    spotter = jump2d.gen_spotter.pattern('[^%s%p]+'),
    labels = 'asdfghjkl',
    view = { dim = false, n_steps_ahead = 2 },
  })

  vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { reverse = true })

  vim.keymap.set({ 'n', 'x', 'o' }, 'sj', function() jump2d.start(jump2d.builtin_opts.single_character) end)
end)
