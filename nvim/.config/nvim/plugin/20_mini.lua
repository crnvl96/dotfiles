require('mini.icons').setup({
    style = 'glyph',
})

require('mini.extra').setup()

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
