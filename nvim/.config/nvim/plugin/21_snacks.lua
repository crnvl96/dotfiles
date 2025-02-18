Add('folke/snacks.nvim')

require('snacks').setup({
    input = { enabled = true },
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
    gitbrowse = {
        notify = true,
        open = function(url) vim.fn.setreg('+', url) end,
    },
    picker = {
        layout = 'ivy',
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
            preview = {
                keys = {
                    ['<a-W>'] = 'cycle_win',
                },
            },
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

                    ['<a-d>'] = false,
                    ['<a-f>'] = false,
                    ['<a-h>'] = false,
                    ['<a-i>'] = false,
                    ['<a-m>'] = false,
                    ['<a-p>'] = false,
                    ['<a-w>'] = false,
                    ['<a-y>'] = false,
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

                    ['<a-d>'] = false,
                    ['<a-f>'] = false,
                    ['<a-h>'] = false,
                    ['<a-i>'] = false,
                    ['<a-m>'] = false,
                    ['<a-p>'] = false,
                    ['<a-w>'] = false,
                    ['<a-y>'] = false,
                },
            },
        },
        layouts = {
            ivy = {
                layout = {
                    box = 'vertical',
                    backdrop = false,
                    row = -1,
                    width = 0,
                    height = 0.5,
                    border = 'top',
                    title = ' {title} {live} {flags}',
                    title_pos = 'left',
                    { win = 'input', height = 1, border = 'bottom' },
                    {
                        box = 'horizontal',
                        { win = 'list', border = 'none' },
                        { win = 'preview', title = '{preview}', width = 0.618, border = 'left' },
                    },
                },
            },
        },
    },
})
