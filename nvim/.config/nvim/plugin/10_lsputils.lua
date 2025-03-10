_G.LSPUtils = {}

LSPUtils.references = {
    name = 'lsp.references',
    dynamic = true,
    execute = function(ctx)
        local Async = require('deck.kit.Async')

        -- Add includeDeclaration parameter
        local params = vim.lsp.util.make_position_params(0, 'utf-16')
        params.context = { includeDeclaration = true }

        -- Get current buffer information
        local current_bufnr = vim.api.nvim_get_current_buf()
        local current_filename = vim.api.nvim_buf_get_name(current_bufnr)
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        local current_col = vim.api.nvim_win_get_cursor(0)[2]

        -- Get word under cursor for display
        local word = vim.fn.expand('<cword>')
        if word == '' then
            ctx.done()
            return
        end

        -- Request references from LSP
        Async.run(function()
            local clients = vim.lsp.get_clients({ bufnr = current_bufnr })
            if #clients == 0 then
                ctx.item({
                    display_text = 'No LSP clients attached to this buffer',
                    data = { error = true },
                })
                ctx.done()
                return
            end

            local results = {}
            local completed = 0
            local client_count = #clients

            for _, client in ipairs(clients) do
                if client.supports_method('textDocument/references') then
                    -- Get the client's offset encoding
                    local offset_encoding = client.offset_encoding or 'utf-16'

                    -- Create position params with explicit encoding
                    local client_params = vim.lsp.util.make_position_params(0, offset_encoding)
                    client_params.context = { includeDeclaration = true }

                    local result = client.request_sync('textDocument/references', client_params, 5000, current_bufnr)
                    completed = completed + 1

                    if result and result.result then
                        for _, location in ipairs(result.result) do
                            table.insert(results, location)
                        end
                    end

                    if completed >= client_count then
                        break -- All clients have responded
                    end
                else
                    completed = completed + 1
                end
            end

            -- Clear the loading message
            ctx.queue(function()
                if #results == 0 then
                    ctx.item({
                        display_text = 'No references found for "' .. word .. '"',
                        data = { error = true },
                    })
                    ctx.done()
                    return
                end

                -- Sort results by filename and position
                table.sort(results, function(a, b)
                    if a.uri ~= b.uri then return a.uri < b.uri end
                    if a.range.start.line ~= b.range.start.line then return a.range.start.line < b.range.start.line end
                    return a.range.start.character < b.range.start.character
                end)

                -- Process and display results
                for _, location in ipairs(results) do
                    local uri = location.uri or location.targetUri
                    local range = location.range or location.targetSelectionRange

                    local filename = vim.uri_to_fname(uri)
                    local short_filename = vim.fn.fnamemodify(filename, ':~:.')

                    -- Try to get the line content
                    local line_content = ''
                    local bufnr = vim.fn.bufnr(filename)
                    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
                        -- Buffer is loaded, get line directly
                        local line_nr = range.start.line
                        if line_nr < vim.api.nvim_buf_line_count(bufnr) then
                            line_content = vim.api.nvim_buf_get_lines(bufnr, line_nr, line_nr + 1, false)[1] or ''
                        end
                    else
                        -- Try to read from file
                        local lines = vim.fn.readfile(filename)
                        if lines and #lines > range.start.line then line_content = lines[range.start.line + 1] or '' end
                    end

                    -- Trim and clean the line content
                    line_content = line_content:gsub('^%s*', ''):gsub('%s*$', '')
                    if line_content == '' then line_content = '<empty line>' end

                    -- Format display text
                    local line_nr = range.start.line + 1
                    local col_nr = range.start.character + 1
                    local is_current = filename == current_filename
                        and line_nr == current_line
                        and math.abs(col_nr - current_col - 1) < 2

                    local prefix = is_current and '→ ' or '  '
                    local display_text =
                        string.format('%s%s:%d:%d: %s', prefix, short_filename, line_nr, col_nr, line_content)

                    ctx.item({
                        display_text = display_text,
                        filter_text = short_filename .. ' ' .. line_content,
                        data = {
                            filename = filename,
                            uri = uri,
                            range = range,
                            line_nr = line_nr,
                            col_nr = col_nr,
                            line_content = line_content,
                            is_current = is_current,
                        },
                    })
                end

                ctx.done()
            end)
        end)
    end,
    actions = {
        {
            name = 'default',
            desc = 'Jump to reference location',
            execute = function(ctx)
                local item = ctx.get_cursor_item()
                if item and not item.data.loading and not item.data.error then
                    -- Hide the picker
                    ctx.hide()

                    -- Jump to the location
                    vim.cmd('edit ' .. vim.fn.fnameescape(item.data.filename))
                    vim.api.nvim_win_set_cursor(0, { item.data.line_nr, item.data.col_nr - 1 })

                    -- Center the cursor
                    vim.cmd('normal! zz')

                    -- Clear all 'Search' highlights
                    vim.cmd('nohlsearch')

                    -- Also clear any namespace highlights we created
                    local ns_id = vim.api.nvim_create_namespace('deck_lsp_references')
                    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
                end
            end,
        },
    },
    previewers = {
        {
            name = 'reference_location',
            preview = function(_, item, env)
                if item.data.loading or item.data.error then return end

                local win = env.win
                if not win then return end
                local ns_id = vim.api.nvim_create_namespace('deck_lsp_references')

                -- Set up an autocommand to clear highlights when the preview window is closed
                vim.api.nvim_create_autocmd('WinClosed', {
                    pattern = tostring(win),
                    callback = function()
                        vim.api.nvim_buf_clear_namespace(vim.fn.bufnr(item.data.filename), ns_id, 0, -1)
                    end,
                })

                -- Open the file in the preview window
                local bufnr = vim.fn.bufadd(item.data.filename)
                vim.fn.bufload(bufnr)
                vim.api.nvim_win_set_buf(win, bufnr)

                -- Set cursor position
                vim.api.nvim_win_set_cursor(win, { item.data.line_nr, item.data.col_nr - 1 })

                -- Center the view
                vim.fn.win_execute(win, 'normal! zz')

                -- Highlight the exact range
                local start_line = item.data.range.start.line
                local start_char = item.data.range.start.character
                local end_line = item.data.range['end'].line
                local end_char = item.data.range['end'].character

                -- Perform a clear before highlighting the item again
                vim.api.nvim_buf_clear_namespace(vim.fn.bufnr(item.data.filename), ns_id, start_line, end_line)

                if start_line == end_line then
                    vim.api.nvim_buf_add_highlight(bufnr, ns_id, 'Search', start_line, start_char, end_char)
                else
                    -- Multi-line highlight

                    vim.api.nvim_buf_add_highlight(bufnr, ns_id, 'Search', start_line, start_char, -1)

                    for line = start_line + 1, end_line - 1 do
                        vim.api.nvim_buf_add_highlight(bufnr, ns_id, 'Search', line, 0, -1)
                    end

                    vim.api.nvim_buf_add_highlight(bufnr, ns_id, 'Search', end_line, 0, end_char)
                end
            end,
        },
    },
}
