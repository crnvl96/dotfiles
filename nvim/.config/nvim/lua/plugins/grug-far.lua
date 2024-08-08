local add = MiniDeps.add

return function()
    add('MagicDuck/grug-far.nvim')

    require('grug-far').setup({ headerMaxWidth = 80 })

    vim.keymap.set('n', '<leader>sr', '<cmd>GrugFar<cr>', { desc = 'replace' })
end
