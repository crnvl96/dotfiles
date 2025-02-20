require('mini.icons').setup({
    style = 'glyph',
})

require('mini.extra').setup()
require('mini.diff').setup({ view = { style = 'number' } })

require('mini.snippets').setup({
    snippets = {
        require('mini.snippets').gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        require('mini.snippets').gen_loader.from_lang(),
    },
})
