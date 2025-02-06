Add('folke/which-key.nvim')

require('which-key').setup({
  preset = 'helix',
  delay = 100,
  icons = { mappings = false },
  show_help = false,
  show_keys = false,
})
