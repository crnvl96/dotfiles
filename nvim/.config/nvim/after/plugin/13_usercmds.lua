vim.api.nvim_create_user_command('Browse', function(args)
    local line_start = nil
    local line_end = nil
    if args.count ~= -1 then
        line_start = args.line1
        line_end = args.line2
    end
    Snacks.gitbrowse({ line_start = line_start, line_end = line_end })
end, { range = true })

vim.api.nvim_create_user_command('Format', function(args)
    local conform = require('conform')

    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
        }
    end
    conform.format({
        range = range,
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = 'fallback',
    })
end, { range = true })

vim.api.nvim_create_user_command('FormatDisable', function(args)
    -- FormatDisable! will disable formatting just for this buffer
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, { desc = 'Disable autoformat-on-save', bang = true })

vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = 'Re-enable autoformat-on-save' })
