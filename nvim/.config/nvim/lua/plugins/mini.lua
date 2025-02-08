require('mini.icons').setup()

require('mini.ai').setup()

require('mini.align').setup({
    mappings = {
        start = 'g|',
        start_with_preview = '',
    },
})

require('mini.operators').setup({
    evaluate = { prefix = 'g=' },
    replace = { prefix = 'g.' },
    exchange = { prefix = '' },
    multiply = { prefix = '' },
    sort = { prefix = '' },
})

require('mini.splitjoin').setup({
    mappings = {
        toggle = 'g_',
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

vim.keymap.set('n', '<Leader>o', function() require('mini.diff').toggle_overlay() end, { desc = 'Overlay' })
