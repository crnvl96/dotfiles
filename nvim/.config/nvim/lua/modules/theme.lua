require('mini.hues').apply_palette(require('mini.hues').make_palette({
  background = vim.o.background == 'dark' and '#212223' or '#e1e2e3',
  foreground = vim.o.background == 'dark' and '#d5d4d3' or '#2f2e2d',
  saturation = vim.o.background == 'dark' and 'lowmedium' or 'mediumhigh',
  accent = 'bg',
}))

require('mini.colors')
  .get_colorscheme()
  :add_transparency({
    float = true,
    statuscolumn = true,
    statusline = true,
    tabline = true,
    winbar = true,
  })
  :apply()
