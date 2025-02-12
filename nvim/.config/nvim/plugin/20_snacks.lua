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
    indent = {
        indent = { enabled = true },
        scope = { enabled = true },
        chunk = { enabled = true },
    },
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
    },
})
