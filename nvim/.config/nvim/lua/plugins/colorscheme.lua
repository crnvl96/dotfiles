local au = vim.api.nvim_create_autocmd
local g = vim.api.nvim_create_augroup

au('ColorScheme', {
  group = g('crnvl96/colorscheme', {}),
  callback = function()
    vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

    vim.cmd('highlight Winbar guibg=none')
  end,
})

MiniDeps.add('rose-pine/neovim')

require('rose-pine').setup()

vim.cmd('colorscheme rose-pine')
