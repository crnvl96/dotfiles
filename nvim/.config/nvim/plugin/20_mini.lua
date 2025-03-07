--- We manage mini nvim plugins library with MiniDeps itself
MiniDeps.add({ name = 'mini.nvim' })

--- Icons provider for nvim
require('mini.icons').setup()
MiniDeps.later(function() require('mini.icons').tweak_lsp_kind() end)

--- Some extra functionality for the mini plugins
--- Other modules, like and `MiniAI` use it
require('mini.extra').setup()

--- Indent scope utilities: highlight the current scope and jump to top/bottom of it
require('mini.indentscope').setup()

--- I don´t need these utilities very much, but once a year, when i need them, they prove being very handy to have on my config
require('mini.align').setup({ mappings = { start = '' } }) --- Align lines
require('mini.splitjoin').setup({ mappings = { toggle = 'S' } }) --- Split/Join lines

require('mini.move').setup()

require('mini.snippets').setup({
    snippets = {
        require('mini.snippets').gen_loader.from_file('~/.config/nvim/snippets/global.json'),
        require('mini.snippets').gen_loader.from_lang(),
    },
})

require('mini.jump2d').setup({
    spotter = require('mini.jump2d').gen_pattern_spotter('[^%s%p]+'),
    view = { dim = true, n_steps_ahead = 2 },
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

require('mini.clue').setup({
    clues = {
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows({ submode_resize = true }),
        require('mini.clue').gen_clues.z(),
    },
    triggers = {
        { mode = 'n', keys = '<Leader>' }, -- Leader triggers
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = '<Localleader>' }, -- Leader triggers
        { mode = 'x', keys = '<Localleader>' },
        { mode = 'n', keys = [[\]] }, -- mini.basics
        { mode = 'n', keys = '[' }, -- mini.bracketed
        { mode = 'n', keys = ']' },
        { mode = 'x', keys = '[' },
        { mode = 'x', keys = ']' },
        { mode = 'i', keys = '<C-x>' }, -- Built-in completion
        { mode = 'n', keys = 'g' }, -- `g` key
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = "'" }, -- Marks
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' }, -- Registers
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' }, -- Window commands
        { mode = 'n', keys = 'z' }, -- `z` key
        { mode = 'x', keys = 'z' },
    },
    window = { config = { width = 'auto' }, delay = 200 },
})
