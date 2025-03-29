local add = MiniDeps.add
local hooks = Utils.MiniDepsHooks()

add('stevearc/oil.nvim')
add('ibhagwan/fzf-lua')
add('stevearc/conform.nvim')
add('tpope/vim-sleuth')
add('tpope/vim-fugitive')
add('nvim-lua/plenary.nvim')
add('lewis6991/gitsigns.nvim')

add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = hooks.treesitter,
})

add({
    source = 'Saghen/blink.cmp',
    hooks = hooks.blink,
    checkout = 'v1.0.0',
})

add({
    source = 'tpope/vim-rhubarb',
    depends = { 'tpope/vim-fugitive' },
})

add({
    source = 'olimorris/codecompanion.nvim',
    depends = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
    },
})

add({
    source = 'ravitemer/mcphub.nvim',
    hooks = hooks.mcphub,
    depends = { 'nvim-lua/plenary.nvim' },
})
