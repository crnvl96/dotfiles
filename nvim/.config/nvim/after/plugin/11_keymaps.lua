vim.g.disable_autoformat = false

vim.keymap.del({ 'x', 'o' }, 'x')
vim.keymap.del({ 'x', 'o' }, 'X')

require('which-key').add({
    {
        mode = { 'n', 'x', 'o' },
        { '|', function() Utils.LeapLineStart() end },
    },
    {
        mode = { 'x', 'o' },
        {
            'OO',
            function()
                local V = vim.fn.mode(true):match('V') and '' or 'V'
                local input = vim.v.count > 1 and (vim.v.count - 1 .. 'j') or 'hl'
                require('leap.remote').action({ input = V .. input, count = false })
            end,
        },
    },
    {
        mode = { 'n', 'x' },
        { '<Leader>a', group = 'AI' },
        { '<Leader>a', '<Cmd>CodeCompanionChat Toggle<CR>', desc = 'Toggle AI chat' },
    },
    {
        mode = 'x',
        { 'ga', ':CodeCompanionChat Add<CR>', desc = 'Add to AI chat' },
    },
    {
        mode = 'n',
        { '-', '<Cmd>Oil<CR>', desc = 'File explorer' },
        { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
        { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },

        { '<Leader>b', group = 'Buffers' },
        { '<Leader>bd', function() Snacks.bufdelete.delete() end, desc = 'Delete buffer' },
        { '<Leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete other buffers' },

        { '<Leader>f', group = 'Files' },
        { '<Leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
        { '<Leader>fl', function() Snacks.picker.lines() end, desc = 'Lines' },
        { '<Leader>fg', function() Snacks.picker.grep({ hidden = true }) end, desc = 'Grep' },
        { '<Leader>fG', function() Snacks.picker.grep_word() end, desc = 'Grep Word' },
        { '<Leader>fh', function() Snacks.picker.help() end, desc = 'Help' },
        { '<Leader>fr', function() Snacks.picker.resume() end, desc = 'Resume' },
        { '<Leader>ff', function() Snacks.picker.files({ hidden = true }) end, desc = 'Files' },
        { '<Leader>fk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },
        { '<Leader>fo', function() Snacks.picker.recent() end, desc = 'Oldfiles' },
        { '<Leader>fp', function() Snacks.picker.pickers() end, desc = 'Pickers' },

        { '<Leader>g', group = 'Git' },
        { '<Leader>gd', '<Cmd>Gvdiffsplit!<CR>', desc = 'Diff' },
        { '<Leader>gg', '<Cmd>G<CR>', desc = 'Git' },
        { '<Leader>go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', desc = 'Overlay' },
        { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Git Browse', mode = { 'n', 'v' } },
        { '<leader>gG', function() Snacks.lazygit() end, desc = 'Lazygit' },

        { '<Leader>o', group = 'Code' },
        { '<Leader>on', '<Cmd>Neogen<CR>', desc = 'Neogen' },

        { '<Leader>s', group = 'Search' },
        {
            '<leader>sr',
            function()
                local grug = require('grug-far')
                local ext = vim.bo.buftype == '' and vim.fn.expand('%:.')
                grug.open({
                    transient = true,
                    prefills = {
                        filesFilter = ext ~= '' and ext or nil,
                    },
                })
            end,
            mode = { 'n', 'v' },
            desc = 'Search and replace in current buf',
        },
        {
            '<leader>sR',
            function()
                local grug = require('grug-far')
                local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
                grug.open({
                    transient = true,
                    prefills = {
                        filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
                    },
                })
            end,
            mode = { 'n', 'v' },
            desc = 'Search and Replace',
        },

        { '<Leader>u', group = 'Toggle' },

        {
            '<leader>N',
            desc = 'Neovim News',
            function()
                Snacks.win({
                    file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
                    width = 0.6,
                    height = 0.6,
                    wo = {
                        spell = false,
                        wrap = false,
                        signcolumn = 'yes',
                        statuscolumn = ' ',
                        conceallevel = 3,
                    },
                })
            end,
        },
    },
})

Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
Snacks.toggle.line_number():map('<leader>ul')
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
Snacks.toggle.diagnostics():map('<leader>ud')
Snacks.toggle.indent():map('<leader>ui')

Snacks.toggle({
    name = 'Autofmt',
    get = function() return not vim.g.disable_autoformat end,
    set = function(state)
        if state then
            vim.g.disable_autoformat = false
        else
            vim.g.disable_autoformat = true
        end
    end,
}):map('<leader>um')
