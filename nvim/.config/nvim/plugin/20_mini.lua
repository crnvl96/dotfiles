require('mini.icons').setup({
    style = 'glyph',
})

require('mini.extra').setup()
require('mini.bracketed').setup()
require('mini.jump').setup()
-- require('mini.pairs').setup()
-- require('mini.statusline').setup()
-- require('mini.tabline').setup({
--     tabpage_section = 'right',
--     format = function(bufnr, label)
--         local suffix = vim.bo[bufnr].modified and '*' or ''
--         return require('mini.tabline').default_format(bufnr, label) .. '[' .. suffix .. bufnr .. '] '
--     end,
-- })

require('mini.operators').setup({
    exchange = {
        prefix = 'gX',
    },
})

require('mini.align').setup({
    mappings = {
        start = '&',
        start_with_preview = '',
    },
})

require('mini.indentscope').setup({
    border = 'both',
    try_as_border = true,
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

require('mini.jump2d').setup({
    spotter = require('mini.jump2d').gen_pattern_spotter('[^%s%p]+'),
    view = { dim = true, n_steps_ahead = 2 },
    mappings = { start_jumping = 'S' },
})

require('mini.surround').setup({
    mappings = {
        add = 'ss',
        delete = 'sx',
        replace = 'sr',
    },
})
