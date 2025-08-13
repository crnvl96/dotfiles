MiniDeps.now(function()
  MiniDeps.add('catppuccin/nvim')

  require('catppuccin').setup({ flavour = 'latte' })

  vim.cmd.colorscheme('catppuccin-latte')
end)
