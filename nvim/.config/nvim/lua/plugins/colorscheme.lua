local hl = vim.api.nvim_set_hl
hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

Add({ source = 'rose-pine/neovim', name = 'rose-pine' })
require('rose-pine').setup()
vim.cmd.colorscheme('rose-pine')
