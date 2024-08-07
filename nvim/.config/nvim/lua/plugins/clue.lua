return function()
    local f = require('functions')
    local au, g = f.au, f.g

    local clue = require('mini.clue')

    clue.setup({
        triggers = {
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = '`' },
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'n', keys = "'" },
            { mode = 'x', keys = "'" },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },
            { mode = 'n', keys = '<C-w>' },
            { mode = 'i', keys = '<C-x>' },
            { mode = 'n', keys = 'z' },
            { mode = 'n', keys = '<leader>' },
            { mode = 'x', keys = '<leader>' },
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },
        },
        clues = {
            { mode = 'n', keys = '[', desc = '+prev' },
            { mode = 'n', keys = ']', desc = '+next' },
            { mode = 'n', keys = '<leader>d', desc = '+dap' },
            { mode = 'n', keys = '<leader>f', desc = '+files' },
            { mode = 'v', keys = '<leader>f', desc = '+files' },
            { mode = 'n', keys = '<leader>s', desc = '+search' },
            { mode = 'v', keys = '<leader>s', desc = '+search' },
            { mode = 'n', keys = '<leader><tab>', desc = '+tabs' },
            clue.gen_clues.builtin_completion(),
            clue.gen_clues.g(),
            clue.gen_clues.marks(),
            clue.gen_clues.registers(),
            clue.gen_clues.windows(),
            clue.gen_clues.z(),
        },
        window = {
            delay = 200,
            scroll_down = '<C-f>',
            scroll_up = '<C-b>',
            config = {
                width = 'auto',
            },
        },
    })

    au('BufReadPost', g('delete_unwanted_keymaps', true), function()
        for _, lhs in ipairs({ '[%', ']%', 'g%' }) do
            vim.keymap.del('n', lhs)
        end
    end, { once = true })
end
