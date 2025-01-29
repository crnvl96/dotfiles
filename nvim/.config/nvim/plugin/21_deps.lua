Utils.Req({
  'selene',
  'tree-sitter',
  'ruff',
  'prettierd',
  'stylua',
  'node',
  'cargo',
  'zoxide',
  'lazydocker',
  'lazygit',
  'aider',
})

Utils.SetNodePath(os.getenv('HOME') .. '/.asdf/installs/nodejs/20.17.0')

local cargo = function(params)
  Later(function() Utils.Build(params, { 'cargo', 'build', '--release' }) end)
end

Add('nvim-lua/plenary.nvim')
Add('folke/snacks.nvim')
Add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })

Add('christoomey/vim-tmux-navigator')
Add('hat0uma/csvview.nvim')
Add('tpope/vim-fugitive')

Add('stevearc/oil.nvim')
Add('stevearc/conform.nvim')

Add('theHamsta/nvim-dap-virtual-text')
Add('mfussenegger/nvim-dap-python')
Add('mfussenegger/nvim-dap')
Add('igorlfs/nvim-dap-view')

Add('olimorris/codecompanion.nvim')

Add('saghen/blink.compat')
Add({ source = 'Saghen/blink.cmp', hooks = { post_install = cargo, post_checkout = cargo } })

Add('neovim/nvim-lspconfig')
