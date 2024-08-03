local au = vim.api.nvim_create_autocmd
local g = vim.api.nvim_create_augroup
local hl = vim.api.nvim_set_hl
local add = MiniDeps.add

au('ColorScheme', {
  group = g('crnvl96/colorscheme', {}),
  callback = function()
    hl(0, 'FloatBorder', { link = 'Normal' })
    hl(0, 'LspInfoBorder', { link = 'Normal' })
    hl(0, 'NormalFloat', { link = 'Normal' })

    vim.cmd('highlight Winbar guibg=none')
  end,
})

add('rose-pine/neovim')

require('rose-pine').setup()

vim.cmd('colorscheme rose-pine')
