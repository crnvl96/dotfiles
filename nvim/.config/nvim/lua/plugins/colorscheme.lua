Add('folke/tokyonight.nvim')
require('tokyonight').setup()

local hl = vim.api.nvim_set_hl
hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })

vim.cmd.colorscheme('tokyonight-night')
