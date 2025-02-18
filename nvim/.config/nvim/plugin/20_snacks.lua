Add('folke/snacks.nvim')

require('snacks').setup({
    notifier = { enabled = true },
    input = { enabled = true },
    statuscolumn = { enabled = true },
    bigfile = {
        size = 1 * 1024 * 1024,
        line_length = 300,
        notify = true,
    },
    image = {
        wo = {
            wrap = false,
            number = false,
            relativenumber = false,
            cursorcolumn = false,
            signcolumn = 'no',
            foldcolumn = '0',
            list = false,
            spell = false,
            statuscolumn = '',
        },
    },
    -- indent = {
    --     indent = { enabled = true },
    --     scope = { enabled = true },
    --     chunk = { enabled = true },
    -- },
    gitbrowse = {
        notify = true,
        open = function(url) vim.fn.setreg('+', url) end,
    },
    picker = {
        matcher = {
            cwd_bonus = true,
            frecency = true,
            history_bonus = true,
        },
        formatters = {
            file = {
                filename_first = false,
                truncate = 120,
            },
        },
        win = {
            input = {
                keys = {
                    ['<a-D>'] = { 'inspect', mode = { 'n', 'i' } },
                    ['<a-F>'] = { 'toggle_follow', mode = { 'i', 'n' } },
                    ['<a-H>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
                    ['<a-I>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
                    ['<a-M>'] = { 'toggle_maximize', mode = { 'i', 'n' } },
                    ['<a-P>'] = { 'toggle_preview', mode = { 'i', 'n' } },
                    ['<a-W>'] = { 'cycle_win', mode = { 'i', 'n' } },
                    ['<a-Y>'] = { 'copy', mode = { 'i', 'n' } },
                },
            },
            list = {
                keys = {
                    ['<a-D>'] = 'inspect',
                    ['<a-F>'] = 'toggle_follow',
                    ['<a-H>'] = 'toggle_hidden',
                    ['<a-I>'] = 'toggle_ignored',
                    ['<a-M>'] = 'toggle_maximize',
                    ['<a-P>'] = 'toggle_preview',
                    ['<a-W>'] = 'cycle_win',
                    ['<a-Y>'] = 'copy',
                },
            },
            preview = {
                keys = {
                    ['<a-W>'] = 'cycle_win',
                },
            },
        },
        layouts = {
            default = {
                layout = {
                    box = 'horizontal',
                    width = 0.8,
                    min_width = 120,
                    height = 0.8,
                    {
                        box = 'vertical',
                        border = 'none',
                        title = '{title} {live} {flags}',
                        { win = 'input', height = 1, border = 'bottom' },
                        { win = 'list', border = 'none' },
                    },
                    { win = 'preview', title = '{preview}', border = 'none', width = 0.5 },
                },
            },
        },
    },
})
