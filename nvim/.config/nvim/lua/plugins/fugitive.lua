return function()
    MiniDeps.add({
        source = 'tpope/vim-rhubarb',
        depends = {
            source = { 'tpope/vim-fugitive' },
        },
    })
end
