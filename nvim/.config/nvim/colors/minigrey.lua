local is_dark = vim.o.background == 'dark'
local bg = is_dark and '#212223' or '#e1e2e3'
local fg = is_dark and '#d5d4d3' or '#2f2e2d'

local hues = require('mini.hues')
local p = hues.make_palette({
  background = bg,
  foreground = fg,
  saturation = is_dark and 'lowmedium' or 'mediumhigh',
  accent = 'bg',
})

local less_p = vim.deepcopy(p)
less_p.orange, less_p.orange_bg = fg, bg
less_p.blue, less_p.blue_bg = fg, bg

hues.apply_palette(less_p)

vim.api.nvim_set_hl(0, 'DiagnosticInfo', { fg = less_p.azure })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { sp = less_p.azure, underline = true })
vim.api.nvim_set_hl(0, 'DiagnosticFloatingInfo', { fg = less_p.azure, bg = less_p.bg_edge })
vim.api.nvim_set_hl(0, 'MiniIconsBlue', { fg = less_p.azure })
vim.api.nvim_set_hl(0, 'MiniIconsOrange', { fg = less_p.yellow })
vim.api.nvim_set_hl(0, '@keyword.return', { fg = less_p.accent, bold = true })
vim.api.nvim_set_hl(0, 'Delimiter', { fg = less_p.fg_edge2 })
vim.api.nvim_set_hl(0, '@markup.heading.1', { fg = less_p.accent, bold = true })

for _, hl in ipairs({
  'BlinkCmpMenu',
  'BlinkCmpMenuBorder',
  'BlinkCmpMenuSelection',
  'BlinkCmpScrollBarThumb',
  'BlinkCmpScrollBarGutter',
  'BlinkCmpLabel',
  'BlinkCmpLabelDeprecated',
  'BlinkCmpLabelMatch',
  'BlinkCmpLabelDetail',
  'BlinkCmpLabelDescription',
  'BlinkCmpKind',
  'BlinkCmpKind',
  'BlinkCmpSource',
  'BlinkCmpGhostText',
  'BlinkCmpDoc',
  'BlinkCmpDocBorder',
  'BlinkCmpDocSeparator',
  'BlinkCmpDocCursorLine',
  'BlinkCmpSignatureHelp',
  'BlinkCmpSignatureHelpBorder',
  'BlinkCmpSignatureHelpActiveParameter',

  'MiniFilesBorder',
  'MiniFilesBorderModified',
  'MiniFilesDirectory',
  'MiniFilesFile',
  'MiniFilesNormal',
  'MiniFilesTitle',
  'MiniFilesTitleFocused',

  'MiniClueBorder',
  'MiniClueDescGroup',
  'MiniClueDescSingle',
  'MiniClueNextKey',
  'MiniClueNextKeyWithPostkeys',
  'MiniClueSeparator',
  'MiniClueTitle',
}) do
  CustomHL(hl, { bg = 'none' })
end

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
