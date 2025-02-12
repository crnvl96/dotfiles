require('mini.icons').setup()
require('mini.extra').setup()
require('mini.bracketed').setup()

require('mini.align').setup({
    mappings = {
        start = '&',
        start_with_preview = '',
    },
})

require('mini.snippets').setup({
    snippets = {
        require('mini.snippets').gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        require('mini.snippets').gen_loader.from_lang(),
    },
})

require('mini.diff').setup({
    view = {
        style = 'sign',
    },
})

require('mini.jump').setup()

local jump2d = require('mini.jump2d')
jump2d.setup({
    spotter = jump2d.gen_pattern_spotter('[^%s%p]+'),
    view = { dim = true, n_steps_ahead = 2 },
    mappings = { start_jumping = 's' },
})

require('mini.files').setup({
    mappings = {
        show_help = '?',
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
    },
    windows = { width_nofocus = 25, preview = true, width_preview = 80 },
})
