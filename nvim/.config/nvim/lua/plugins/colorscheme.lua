return function()
    MiniDeps.add('EdenEast/nightfox.nvim')

    require('nightfox').setup({
        options = { transparent = true },
    })

    vim.cmd('colorscheme duskfox')
end
