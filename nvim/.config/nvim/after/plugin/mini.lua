require('mini.icons').setup()

require('mini.diff').setup({
    view = {
        style = 'sign',
    },
})

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

require('mini.clue').setup({
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
        { mode = 'n', keys = '<leader>c', desc = '+code' },
        { mode = 'n', keys = '<leader>f', desc = '+find' },
        { mode = 'n', keys = '<leader>l', desc = '+lsp' },
        { mode = 'n', keys = '[', desc = '+prev' },
        { mode = 'n', keys = ']', desc = '+next' },

        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),

        -- mark clues
        function()
            local marks = {}
            vim.list_extend(marks, vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
            vim.list_extend(marks, vim.fn.getmarklist())

            return vim.iter(marks)
                :map(function(mark)
                    local key = mark.mark:sub(2, 2)

                    -- Just look at letter marks.
                    if not string.match(key, '^%a') then return nil end

                    -- For global marks, use the file as a description.
                    -- For local marks, use the line number and content.
                    local desc
                    if mark.file then
                        desc = vim.fn.fnamemodify(mark.file, ':p:~:.')
                    elseif mark.pos[1] and mark.pos[1] ~= 0 then
                        local line_num = mark.pos[2]
                        local lines = vim.fn.getbufline(mark.pos[1], line_num)
                        if lines and lines[1] then
                            desc = string.format('%d: %s', line_num, lines[1]:gsub('^%s*', ''))
                        end
                    end

                    if desc then return { mode = 'n', keys = string.format('`%s', key), desc = desc } end
                end)
                :totable()
        end,

        -- macro clues
        function()
            local res = {}
            for _, register in ipairs(vim.split('abcdefghijklmnopqrstuvwxyz', '')) do
                local keys = string.format('"%s', register)
                local ok, desc = pcall(vim.fn.getreg, register)
                if ok and desc ~= '' then
                    desc = string.format('register: %s', desc:gsub('%s+', ' '))
                    table.insert(res, { mode = 'n', keys = keys, desc = desc })
                    table.insert(res, { mode = 'v', keys = keys, desc = desc })
                end
            end

            return res
        end,
    },
    window = {
        delay = 200,
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
        config = function(bufnr)
            local max_width = 0
            for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
                max_width = math.max(max_width, vim.fn.strchars(line))
            end

            max_width = max_width + 2

            return {
                width = math.min(70, max_width),
            }
        end,
    },
})
