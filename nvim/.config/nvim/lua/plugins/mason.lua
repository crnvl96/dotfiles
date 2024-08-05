local add = MiniDeps.add

add({
  source = 'williamboman/mason.nvim',
  hooks = {
    post_checkout = function() vim.cmd('MasonUpdate') end,
  },
})

local mason = require('mason')
mason.setup()
