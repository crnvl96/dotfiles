local p = require('utils.pack')

MiniDeps.add({
  source = 'mason-org/mason.nvim',
  monitor = 'main',
  hooks = {
    post_checkout = function() vim.cmd('MasonUpdate') end,
  },
})

MiniDeps.add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'main',
  hooks = {
    post_checkout = function() vim.cmd('TSUpdate') end,
  },
})

MiniDeps.add({
  source = 'Saghen/blink.cmp',
  checkout = 'v1.6.0',
  monitor = 'main',
})

MiniDeps.add({
  source = 'dmtrKovalenko/fff.nvim',
  hooks = {
    post_install = function(params) p.build(params, 'cargo +nightly build --release') end,
    post_checkout = function(params) p.build(params, 'cargo +nightly build --release') end,
  },
})

MiniDeps.add({
  source = 'mrcjkb/rustaceanvim',
  version = 'v6.9.1',
  monitor = 'master',
})

MiniDeps.add({ source = 'b0o/SchemaStore.nvim' })
MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
MiniDeps.add({ source = 'nvim-lua/plenary.nvim' })
MiniDeps.add({ source = 'olimorris/codecompanion.nvim' })
MiniDeps.add({ source = 'stevearc/conform.nvim' })
MiniDeps.add({ source = 'Saecki/crates.nvim' })
MiniDeps.add({ source = 'MagicDuck/grug-far.nvim' })
MiniDeps.add({ source = 'tpope/vim-sleuth' })
MiniDeps.add({ source = 'folke/snacks.nvim' })
MiniDeps.add({ source = 'brianhuster/unnest.nvim' })
MiniDeps.add({ source = 'jglasovic/venv-lsp.nvim' })

-- MiniDeps.add({ source = 'tpope/vim-fugitive' })
