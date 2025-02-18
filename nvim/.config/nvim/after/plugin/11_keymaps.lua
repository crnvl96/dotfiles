require('which-key').add({
    {
        mode = { 'n', 'x' },
        { '<Leader>a', '<Cmd>CodeCompanionChat Toggle<CR>', desc = 'Toggle AI chat' },
    },
    {
        mode = 'v',
        { 'ga', ':CodeCompanionChat Add<CR>', desc = 'Add to AI chat' },
    },
    {
        mode = 'n',
        { '<Leader>b', group = 'Buffers' },
        { '<Leader>bd', function() Snacks.bufdelete.delete() end, desc = 'Delete buffer' },
        { '<Leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete other buffers' },

        { '<Leader>,', function() Snacks.picker.buffers() end, desc = 'Buffers' },
        { '<Leader>/', function() Snacks.picker.lines() end, desc = 'Lines' },
        { '<Leader>G', function() Snacks.picker.grep_word() end, desc = 'Grep Word' },
        { '<Leader>c', function() Snacks.picker.resume() end, desc = 'Resume' },
        { '<Leader>d', '<Cmd>Gvdiffsplit!<CR>', desc = 'Diff' },
        { '<Leader>e', '<Cmd>Oil<CR>', desc = 'File explorer' },
        { '<Leader>f', function() Snacks.picker.files({ hidden = true }) end, desc = 'Files' },
        { '<Leader>g', function() Snacks.picker.grep({ hidden = true }) end, desc = 'Grep' },
        { '<Leader>h', function() Snacks.picker.help() end, desc = 'Help' },
        { '<Leader>i', '<Cmd>G<CR>', desc = 'Git' },
        { '<Leader>k', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
        { '<Leader>n', '<Cmd>Neogen<CR>', desc = 'Neogen' },
        { '<Leader>o', function() Snacks.picker.recent() end, desc = 'Oldfiles' },
        { '<Leader>p', function() Snacks.picker.pickers() end, desc = 'Pickers' },
        {
            ']c',
            function()
                if vim.wo.diff then
                    return ']c'
                else
                    vim.schedule(function() require('treesitter-context').go_to_context() end)
                    return '<Ignore>'
                end
            end,
            desc = 'Jump to upper context',
            expr = true,
        },
    },
})
