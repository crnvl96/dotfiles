local add = MiniDeps.add
local au = vim.api.nvim_create_autocmd
local hl = vim.api.nvim_set_hl
local group = vim.api.nvim_create_augroup('crnvl96/colorscheme', {})

au('ColorScheme', {
  group = group,
  callback = function()
    hl(0, 'FloatBorder', { link = 'Normal' })
    hl(0, 'LspInfoBorder', { link = 'Normal' })
    hl(0, 'NormalFloat', { link = 'Normal' })

    vim.cmd('highlight Winbar guibg=none')
  end,
})

add('NTBBloodbath/doom-one.nvim')

vim.cmd('colorscheme doom-one')

-- require('rose-pine').setup()
--
-- vim.cmd('colorscheme rose-pine')
