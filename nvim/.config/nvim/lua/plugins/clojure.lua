local add = MiniDeps.add

return function()
    add({
        source = 'Olical/conjure',
        depends = {
            { source = 'tpope/vim-dispatch' },
            { source = 'clojure-vim/vim-jack-in' },
            { source = 'radenling/vim-dispatch-neovim' },
        },
    })
end
