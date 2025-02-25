Add('nvim-lua/plenary.nvim')
Add({ source = 'williamboman/mason.nvim', hooks = { post_checkout = function() vim.cmd('MasonUpdate') end } })

Add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })
Add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })

Add('andymass/vim-matchup')

Add('folke/snacks.nvim')
Add('folke/which-key.nvim')

Add('ggandor/flit.nvim')
Add('ggandor/leap.nvim')

Add('tpope/vim-fugitive')
Add('tpope/vim-repeat')
Add('tpope/vim-sleuth')

Add('stevearc/conform.nvim')
Add('stevearc/oil.nvim')
Add('stevearc/quicker.nvim')

Add('danymat/neogen')
Add('MagicDuck/grug-far.nvim')

Add({ source = 'saghen/blink.compat' })
Add({ source = 'Saghen/blink.cmp', hooks = { post_install = Utils.BuildBlink, post_checkout = Utils.BuildBlink } })

Add('j-hui/fidget.nvim')
Add('olimorris/codecompanion.nvim')

Add('neovim/nvim-lspconfig')
