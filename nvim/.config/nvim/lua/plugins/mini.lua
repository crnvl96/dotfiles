local function map_split(buf_id, lhs, direction)
    local minifiles = require('mini.files')

    local function rhs()
        local window = minifiles.get_explorer_state().target_window

        if window == nil or minifiles.get_fs_entry().fs_type == 'directory' then return end

        local new_target_window
        vim.api.nvim_win_call(window, function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
        end)

        minifiles.set_target_window(new_target_window)

        minifiles.go_in({ close_on_file = true })
    end

    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = 'Split ' .. string.sub(direction, 12) })
end

-- Plugin definitions

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

require('mini.files').setup({
    mappings = {
        show_help = '?',
        go_in = 'l',
        go_in_plus = 'L',
        go_out = 'h',
        go_out_plus = 'H',
        reset = ';',
    },
    windows = { width_nofocus = 25, preview = true, width_preview = 80 },
})

vim.api.nvim_create_autocmd('User', {
    desc = 'Add rounded corners to minifiles window',
    pattern = 'MiniFilesWindowOpen',
    callback = function(args) vim.api.nvim_win_set_config(args.data.win_id, { border = 'rounded' }) end,
})

vim.api.nvim_create_autocmd('User', {
    desc = 'Add minifiles split keymaps',
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local buf_id = args.data.buf_id
        map_split(buf_id, '<C-s>', 'belowright horizontal')
        map_split(buf_id, '<C-v>', 'belowright vertical')
    end,
})

vim.keymap.set('n', '<Leader>e', function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.fnamemodify(bufname, ':p')
    if path and vim.uv.fs_stat(path) then require('mini.files').open(bufname, false) end
end, { desc = 'File explorer' })

vim.keymap.set('n', '<Leader>o', function() require('mini.diff').toggle_overlay() end, { desc = 'Overlay' })
