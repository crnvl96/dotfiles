require('mini.icons').setup()
require('mini.jump').setup()

require('mini.snippets').setup({
    snippets = {
        require('mini.snippets').gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        require('mini.snippets').gen_loader.from_lang(),
    },
})

require('mini.operators').setup({
    evaluate = { prefix = 'g=' },
    replace = { prefix = 's' },
    exchange = { prefix = '' },
    multiply = { prefix = '' },
    sort = { prefix = '' },
})

require('mini.ai').setup({
    n_lines = 500,
    custom_textobjects = {
        o = require('mini.ai').gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        a = require('mini.ai').gen_spec.treesitter({ a = '@parameter.outer', i = '@parameter.inner' }),
        t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
        G = require('mini.extra').gen_ai_spec.buffer(),
        d = require('mini.extra').gen_ai_spec.diagnostic(),
        i = require('mini.extra').gen_ai_spec.indent(),
        n = require('mini.extra').gen_ai_spec.number(),
        e = {
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
        },
    },
    silent = true,
    search_method = 'cover',
    mappings = {
        around_next = '',
        inside_next = '',
        around_last = '',
        inside_last = '',
    },
})
