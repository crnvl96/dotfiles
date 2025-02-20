vim.api.nvim_create_user_command('Fmt', function(args)
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
