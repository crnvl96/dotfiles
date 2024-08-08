local add = MiniDeps.add

return function()
    add('stevearc/quicker.nvim')

    require('quicker').setup({
        opts = {
            buflisted = false,
            number = false,
            relativenumber = false,
            signcolumn = 'auto',
            winfixheight = true,
            wrap = false,
        },
        keys = {
            {
                '>',
                function() require('quicker').expand({ before = 2, after = 2, add_to_existing = true }) end,
                desc = 'Expand quickfix context',
            },
            {
                '<',
                function() require('quicker').collapse() end,
                desc = 'Collapse quickfix context',
            },
        },
    })

    vim.keymap.set('n', '<leader>q', function() require('quicker').toggle() end, {
        desc = 'Toggle quickfix',
    })

    vim.keymap.set('n', '<leader>l', function() require('quicker').toggle({ loclist = true }) end, {
        desc = 'Toggle loclist',
    })
end
