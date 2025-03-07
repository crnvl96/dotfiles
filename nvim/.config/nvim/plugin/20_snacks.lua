MiniDeps.add('folke/snacks.nvim')

--- TODO: keep an eye at
---   - https://github.com/olimorris/codecompanion.nvim/issues/968
---   - https://github.com/Saghen/blink.cmp/issues/1303
require('snacks').setup({
    input = {
        enabled = true,
    },
    bigfile = {
        enabled = true,
    },
    picker = {
        layout = {
            preset = 'ivy',
        },
        sources = {
            explorer = {
                layout = {
                    layout = {
                        position = 'right',
                    },
                },
            },
        },
        layouts = {
            sidebar = {
                preview = 'main',
                layout = {
                    backdrop = false,
                    width = 80,
                    min_width = 40,
                    height = 0,
                    position = 'left',
                    border = 'none',
                    box = 'vertical',
                    {
                        win = 'input',
                        height = 1,
                        border = 'rounded',
                        title = '{title} {live} {flags}',
                        title_pos = 'center',
                    },
                    { win = 'list', border = 'none' },
                    { win = 'preview', title = '{preview}', height = 0.4, border = 'top' },
                },
            },
        },
    },
})
