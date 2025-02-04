Add('folke/which-key.nvim')

require('which-key').setup({
  preset = 'helix',
  triggers = {
    { '<auto>', mode = 'nxso' },
  },
  icons = {
    mappings = false,
  },
  show_help = false,
  show_keys = false,
})

require('which-key').add({
  {
    mode = { 'n' },
    { '<leader>b', group = 'Buffer' },
    { '<leader>c', group = 'Code' },
    { '<leader>d', group = 'Dap' },
    { '<leader>f', group = 'Find' },
    { '<leader>g', group = 'Git' },
    { '<leader>l', group = 'LSP' },
    { '<leader>n', group = 'Notification' },
    { '<leader>s', group = 'Search' },
    { '<leader>u', group = 'Toggle' },
  },
  {
    mode = { 'n', 'v' },
    { '<leader>c', group = 'Code' },
    { '<leader>d', group = 'Dap' },
    { '<leader>g', group = 'Git' },
    { '<leader>s', group = 'Search' },
  },
})
