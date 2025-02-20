Add('folke/snacks.nvim')

require('snacks').setup({
    input = { enabled = true },
    words = { enabled = true },
    scope = { enabled = true },
    bigfile = {
        size = 1 * 1024 * 1024,
        line_length = 300,
        notify = true,
    },
    indent = {
        enabled = false,
        indent = {
            enabled = true,
            only_scope = false,
            only_current = false,
        },
        scope = {
            enabled = true,
            underline = false,
            only_current = false,
        },
        chunk = {
            enabled = true,
            only_current = false,
        },
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
                    ['<a-w>'] = 'cycle_win',
                },
            },
            input = {
                keys = {
                    ['<a-h>'] = false,
                    ['<a-H>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
                    ['<a-y>'] = { 'copy', mode = { 'i', 'n' } },
                },
            },
            list = {
                keys = {
                    ['<a-h>'] = false,
                    ['<a-H>'] = 'toggle_hidden',
                    ['<a-y>'] = 'copy',
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
