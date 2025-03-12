local hooks = Utils.MiniDepsHooks()

MiniDeps.add('folke/snacks.nvim')

--- These plugins don't require the `setup` call to work
MiniDeps.add('nvim-lua/plenary.nvim') -- libraty
MiniDeps.add('tpope/vim-eunuch') -- unix operations
MiniDeps.add('tpope/vim-fugitive') -- git
MiniDeps.add('tpope/vim-rhubarb') -- github links

MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter', hooks = hooks.treesitter })
MiniDeps.add('nvim-treesitter/nvim-treesitter-textobjects')
MiniDeps.add('MagicDuck/grug-far.nvim')
MiniDeps.add({ source = 'Saghen/blink.cmp', hooks = hooks.blink })

--- LSP/Formatting features
MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add('neovim/nvim-lspconfig')

--- Some plugins to provide AI integration
MiniDeps.add({ source = 'olimorris/codecompanion.nvim', depends = { 'j-hui/fidget.nvim' } })
MiniDeps.add('GeorgesAlkhouri/nvim-aider')

-- Documentation utilities
MiniDeps.add('danymat/neogen')

-- Quickfix
MiniDeps.add({ source = 'junegunn/fzf', hooks = hooks.fzf })
MiniDeps.add('stevearc/quicker.nvim')
MiniDeps.add('kevinhwang91/nvim-bqf')
