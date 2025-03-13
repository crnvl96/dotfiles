local add = MiniDeps.add
local hooks = Utils.MiniDepsHooks()

add('stevearc/oil.nvim')
add('ibhagwan/fzf-lua')
add('stevearc/conform.nvim')

add({
    source = 'nvim-treesitter/nvim-treesitter-textobjects',
    depends = {
        { source = 'nvim-treesitter/nvim-treesitter', hooks = hooks.treesitter },
    },
})

add({
    source = 'tpope/vim-rhubarb',
    depends = { 'tpope/vim-fugitive' },
})

add({
    source = 'neovim/nvim-lspconfig',
    depends = {
        { source = 'Saghen/blink.cmp', hooks = hooks.blink },
    },
})

add({
    source = 'olimorris/codecompanion.nvim',
    depends = {
        { source = 'j-hui/fidget.nvim' },
        { source = 'nvim-lua/plenary.nvim' },
    },
})

add({
    source = 'ravitemer/mcphub.nvim',
    hooks = hooks.mcphub,
    depends = {
        { source = 'nvim-lua/plenary.nvim' },
    },
})
