Add('nvim-lua/plenary.nvim')

require('mini.align').setup()
require('mini.ai').setup()
require('mini.operators').setup({
  evaluate = { prefix = 'g=' },
  exchange = { prefix = '' },
  multiply = { prefix = '' },
  replace = { prefix = 'gr' },
  sort = { prefix = '' },
})
require('mini.splitjoin').setup()
require('mini.pick').setup()
require('mini.diff').setup({ view = { style = 'sign' } })
