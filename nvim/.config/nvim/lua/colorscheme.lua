vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('crnvl96/colorscheme', {}),
  callback = function()
    vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'Normal' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })

    vim.cmd('highlight Winbar guibg=none')
  end,
})

require('mini.hues').setup({
  background = '#151515',
  foreground = '#c5c9c5',
  n_hues = 2,
  saturation = 'medium',
  accent = 'blue',
})
