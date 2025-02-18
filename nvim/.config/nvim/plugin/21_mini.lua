require('mini.icons').setup()
require('mini.extra').setup()

require('mini.align').setup({
    mappings = {
        start = '&',
        start_with_preview = '',
    },
})

require('mini.operators').setup()

require('mini.indentscope').setup({
    -- Type of scope's border: which line(s) with smaller indent to
    -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
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

require('mini.jump').setup()

local jump2d = require('mini.jump2d')
jump2d.setup({
    spotter = jump2d.gen_pattern_spotter('[^%s%p]+'),
    view = { dim = true, n_steps_ahead = 2 },
    mappings = { start_jumping = '<CR>' },
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

require('mini.surround').setup({
    mappings = {
        add = 'ss',
        delete = 'sx',
        replace = 'sr',
    },
})

local pairs = require('mini.pairs')
pairs.setup({ modes = { insert = true, command = true, terminal = false } })

local open = pairs.open
pairs.open = function(pair, neigh_pattern)
    if vim.fn.getcmdline() ~= '' then return open(pair, neigh_pattern) end
    local o, c = pair:sub(1, 1), pair:sub(2, 2)
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local next = line:sub(cursor[2] + 1, cursor[2] + 1)
    local before = line:sub(1, cursor[2])

    -- better deal with markdown code blocks
    if o == '`' and vim.bo.filetype == 'markdown' and before:match('^%s*``') then
        return '`\n```' .. vim.api.nvim_replace_termcodes('<up>', true, true, true)
    end

    -- skip autopair when next character is one of these
    local skip_next = [=[[%w%%%'%[%"%.%`%$]]=]
    if next ~= '' and next:match(skip_next) then return o end

    -- skip autopair when the cursor is inside these treesitter nodes
    local skip_ts = { 'string' }
    local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
    for _, capture in ipairs(ok and captures or {}) do
        if vim.tbl_contains(skip_ts, capture.capture) then return o end
    end

    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    if next == c and c ~= o then
        local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), '')
        local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), '')
        if count_close > count_open then return o end
    end

    return open(pair, neigh_pattern)
end
