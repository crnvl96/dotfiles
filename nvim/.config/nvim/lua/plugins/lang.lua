return function()
    -- clojure
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('crnvl96/format_opts', {}),
        pattern = { 'clojure' },
        callback = function()
            MiniDeps.add({
                source = 'Olical/conjure',
                depends = {
                    { source = 'tpope/vim-dispatch' },
                    { source = 'clojure-vim/vim-jack-in' },
                    { source = 'radenling/vim-dispatch-neovim' },
                },
            })
        end,
    })

    -- go
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('crnvl96/format_opts', {}),
        pattern = { 'go' },
        callback = function() vim.cmd('setlocal shiftwidth=4 tabstop=4') end,
    })
end
