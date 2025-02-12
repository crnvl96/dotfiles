Add({ source = 'nvim-treesitter/nvim-treesitter', hooks = { post_checkout = function() vim.cmd('TSUpdate') end } })
Add({ source = 'nvim-treesitter/nvim-treesitter-textobjects' })

require('nvim-treesitter.configs').setup({
    highlight = { enable = true },
    indent = { enable = true, disable = { 'yaml' } },
    sync_install = false,
    auto_install = true,
    ensure_installed = {
        'c',
        'vim',
        'vimdoc',
        'query',
        'markdown',
        'markdown_inline',
        'lua',
        'javascript',
        'typescript',
        'tsx',
        'python',
        'sql',
        'csv',
    },
    textobjects = {
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                [']f'] = { query = '@function.outer', desc = 'Next function start' },
                [']c'] = { query = '@class.outer', desc = 'Next class start' },
            },
            goto_previous_start = {
                ['[f'] = { query = '@function.outer', desc = 'Prev function start' },
                ['[c'] = { query = '@class.outer', desc = 'Prev class start' },
            },
        },
    },
})

local ai = require('mini.ai')

ai.setup({
    n_lines = 500,
    custom_textobjects = {
        o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
        }),
        f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
        c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }),
        g = function()
            local from = { line = 1, col = 1 }
            local to = {
                line = vim.fn.line('$'),
                col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
        end,
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
