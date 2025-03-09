local hooks = Utils.MiniDepsHooks()

--- These plugins don't require the `setup` call to work
MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add('andymass/vim-matchup')
MiniDeps.add('tpope/vim-fugitive')
MiniDeps.add('tpope/vim-sleuth')
MiniDeps.add('tpope/vim-eunuch')
MiniDeps.add('tpope/vim-rhubarb')

MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter', hooks = hooks.treesitter })
MiniDeps.add('nvim-treesitter/nvim-treesitter-textobjects')
MiniDeps.add('MagicDuck/grug-far.nvim')
MiniDeps.add({ source = 'Saghen/blink.cmp', hooks = hooks.blink })

--- LSP/Formatting features
MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add('neovim/nvim-lspconfig')

--- Some plugins to provide AI integration
MiniDeps.add({ source = 'olimorris/codecompanion.nvim', depends = { 'j-hui/fidget.nvim' } })

-- Picker/Explorer
MiniDeps.add('hrsh7th/nvim-deck')
