Add({ source = 'nvim-lua/plenary.nvim' })
Add({ source = 'tpope/vim-fugitive' })
Add({ source = 'danymat/neogen' })
Add({ source = 'MagicDuck/grug-far.nvim' })

require('mini.base16').setup({
    palette = Utils.Palette(),
    use_cterm = true,
    plugins = { default = true },
})

require('neogen').setup({
    snippet_engine = 'mini',
    languages = {
        lua = { template = { annotation_convention = 'emmylua' } },
        python = { template = { annotation_convention = 'numpydoc' } },
    },
})

require('grug-far').setup()
