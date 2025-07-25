--   vim.cmd('set rtp+=~/Developer/personal/lazydocker.nvim/')

MiniDeps.now(function()
  MiniDeps.add({ name = 'mini.nvim' })
  MiniDeps.add('neovim/nvim-lspconfig')
  MiniDeps.add('tpope/vim-fugitive')
end)
