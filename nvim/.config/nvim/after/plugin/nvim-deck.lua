local deck = require('deck')
local Async = require('deck.kit.Async')
local Position = require('deck.kit.LSP.Position')
local Client = require('deck.kit.LSP.Client')

local set = vim.keymap.set
local usercmd = vim.api.nvim_create_user_command

require('deck.easy').setup()

local ns = vim.api.nvim_create_namespace('deck_lsp_definitions')

local function clear_highlights(bufnr) vim.api.nvim_buf_clear_namespace(bufnr or 0, ns, 0, -1) end

local function get_line_content(filename, line_nr)
    local bufnr = vim.fn.bufnr(filename)

    -- Buffer is loaded, get line directly
    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
        if line_nr < vim.api.nvim_buf_line_count(bufnr) then
            return vim.api.nvim_buf_get_lines(bufnr, line_nr, line_nr + 1, false)[1] or ''
        end
    else
        -- Try to read from file
        local lines = vim.fn.readfile(filename)
        if lines and #lines > line_nr then return lines[line_nr + 1] or '' end
    end

    return ''
end

local function flatten_symbols(symbols_list, result, level)
    level = level or 0
    result = result or {}

    for _, symbol in ipairs(symbols_list) do
        symbol.level = level
        table.insert(result, symbol)

        if symbol.children and #symbol.children > 0 then flatten_symbols(symbol.children, result, level + 1) end
    end

    return result
end

deck.register_action({
    name = 'send_to_qf',
    resolve = function(ctx) return #ctx.get_action_items() >= 1 and ctx.get_action_items()[1].data.filename end,
    execute = function(ctx)
        local selected_items = ctx.get_selected_items()
        local qf_list = {}

        for _, item in ipairs(selected_items) do
            local data = item.data
            table.insert(qf_list, {
                filename = data.filename,
                lnum = data.lnum or 1,
                col = data.col or 1,
                text = item.display_text or '',
            })
        end

        ctx.hide()
        vim.fn.setqflist(qf_list, 'r')
        vim.cmd('copen')
    end,
})

deck.register_action({
    name = 'lsp_default_open_action',
    execute = function(ctx)
        local item = ctx.get_cursor_item()
        if item and not item.data.loading and not item.data.error then
            ctx.hide()
            vim.cmd('edit ' .. vim.fn.fnameescape(item.data.filename))
            vim.api.nvim_win_set_cursor(0, { item.data.line_nr, item.data.col_nr - 1 })
            vim.cmd('normal! zz')
            clear_highlights()
        end
    end,
})

deck.register_previewer({
    name = 'lsp_previewer',
    preview = function(_, item, env)
        if item.data.loading or item.data.error then return end
        local win = env.win
        if not win then return end

        vim.api.nvim_create_autocmd('WinClosed', {
            pattern = tostring(win),
            callback = function() clear_highlights(vim.fn.bufnr(item.data.filename)) end,
        })

        local bufnr = vim.fn.bufadd(item.data.filename)
        vim.fn.bufload(bufnr)
        vim.api.nvim_win_set_buf(win, bufnr)
        vim.api.nvim_win_set_cursor(win, { item.data.line_nr, item.data.col_nr - 1 })
        vim.fn.win_execute(win, 'normal! zz')
        clear_highlights(bufnr)

        local start_line = item.data.range.start.line
        local start_char = item.data.range.start.character
        local end_line = item.data.range['end'].line
        local end_char = item.data.range['end'].character

        -- Single line highlight
        if start_line == end_line then
            vim.api.nvim_buf_add_highlight(bufnr, ns, 'Search', start_line, start_char, end_char)
        else
            -- Multi-line highlight
            vim.api.nvim_buf_add_highlight(bufnr, ns, 'Search', start_line, start_char, -1)

            for line = start_line + 1, end_line - 1 do
                vim.api.nvim_buf_add_highlight(bufnr, ns, 'Search', line, 0, -1)
            end

            vim.api.nvim_buf_add_highlight(bufnr, ns, 'Search', end_line, 0, end_char)
        end
    end,
})

deck.register_decorator({
    name = 'lsp_treesitter_decorator',
    resolve = function(_, item) return item.data.bufnr and item.data.lnum and item.data.content_offset end,
    decorate = function(_, item)
        local extmarks = {}
        local bufnr = item.data.bufnr

        -- Highlight the prefix with fixed color
        if item.data.prefix then
            table.insert(extmarks, {
                col = 0,
                end_col = #item.data.prefix,
                hl_group = 'Comment', -- Use Directory highlight for the filename and metadata
                priority = 200,
            })
        end

        local highlighter = vim.treesitter.highlighter.active[bufnr]
        if not highlighter then return extmarks end

        -- Get original line and calculate whitespace offset
        local row = item.data.lnum - 1
        local orig_line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
        local whitespace_count = #(orig_line:match('^%s*') or '')

        highlighter:for_each_highlight_state(function(state)
            local root_node = state.tstree:root()
            local root_start_row, _, root_end_row, _ = root_node:range()

            -- Skip if outside range
            if root_start_row > row or root_end_row < row then return end

            for capture, node, metadata in state.highlighter_query:query():iter_captures(root_node, bufnr, row, row + 1) do
                if capture then
                    local start_row, start_col, end_row, end_col = node:range()

                    -- Only apply highlighting if node intersects with our target row
                    if start_row <= row and row <= end_row then
                        -- Calculate visible portion on our target row
                        local visible_start = start_row == row and start_col or 0
                        local visible_end = end_row == row and end_col or #orig_line

                        -- Adjust for whitespace trimming in display
                        local display_start = visible_start >= whitespace_count and (visible_start - whitespace_count)
                            or 0
                        local display_end = visible_end >= whitespace_count and (visible_end - whitespace_count) or 0

                        -- Apply content offset to match position in display
                        if item.data.content_offset then
                            display_start = display_start + item.data.content_offset
                            display_end = display_end + item.data.content_offset
                        end

                        -- Get highlight group
                        local hl_id = state.highlighter_query:get_hl_from_capture(capture)
                        if hl_id and display_end > display_start then
                            table.insert(extmarks, {
                                col = display_start,
                                end_col = display_end,
                                hl_group = hl_id,
                                priority = tonumber(
                                    metadata.priority or metadata[capture] and metadata[capture].priority
                                ) or 100,
                                conceal = metadata.conceal or metadata[capture] and metadata[capture].conceal,
                            })
                        end
                    end
                end
            end
        end)

        return extmarks
    end,
})

deck.register_decorator({
    name = 'lsp_regex_decorator',
    resolve = function(_, item) return item.data.bufnr and item.data.lnum and not item.data.content_offset end,
    decorate = function(_, item)
        local extmarks = {}

        -- Extract prefix and content parts
        local prefix = item.data.prefix

        if prefix then
            -- Highlight specific patterns in the prefix
            if prefix:match('%[ERROR%]') then
                table.insert(extmarks, {
                    col = prefix:find('%[ERROR%]'),
                    end_col = prefix:find('%[ERROR%]') + 5, -- length of "[ERROR]"
                    hl_group = 'DiagnosticError',
                    priority = 110,
                })
            elseif prefix:match('%[WARN%]') then
                table.insert(extmarks, {
                    col = prefix:find('%[WARN%]'),
                    end_col = prefix:find('%[WARN%]') + 2, -- length of "warn"
                    hl_group = 'DiagnosticWarn',
                    priority = 110,
                })
            elseif prefix:match('%[INFO%]') then
                table.insert(extmarks, {
                    col = prefix:find('%[INFO%]'),
                    end_col = prefix:find('%[INFO%]') + 2, -- length of "info"
                    hl_group = 'DiagnosticInfo',
                    priority = 110,
                })
            elseif prefix:match('%[HINT%]') then
                table.insert(extmarks, {
                    col = prefix:find('%[HINT%]'),
                    end_col = prefix:find('%[HINT%]') + 2, -- length of "hint"
                    hl_group = 'DiagnosticHint',
                    priority = 110,
                })
            end

            -- Highlight the content part as Comment (original behavior)
            table.insert(extmarks, {
                col = #prefix,
                end_col = #item.display_text,
                hl_group = 'Comment',
                priority = 100,
            })
        end

        return extmarks
    end,
})

local function fetch_lsp(ctx, method, include_declaration)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local buf = vim.api.nvim_get_current_buf()
    local current_filename = vim.api.nvim_buf_get_name(buf)
    local current_line = cursor_pos[1]
    local current_col = cursor_pos[2]
    local word = vim.fn.expand('<cword>')

    ctx.on_abort(function() clear_highlights(buf) end)

    if word == '' then
        ctx.done()
        return
    end

    return Async.run(function()
        local clients = vim.lsp.get_clients({ bufnr = buf })

        if #clients == 0 then
            ctx.item({
                display_text = 'No LSP clients attached to this buffer',
                data = { error = true },
            })
            ctx.done()
            return
        end

        local tasks = {}

        for _, client in ipairs(clients) do
            if client.supports_method(method) then
                local client_wrapper = Client.new(client)
                local params = {
                    textDocument = { uri = vim.uri_from_bufnr(buf) },
                    position = Position.cursor(),
                }

                if include_declaration ~= nil and method == 'textDocument/references' then
                    params.context = { includeDeclaration = include_declaration }
                end

                table.insert(
                    tasks,
                    Async.run(
                        function() return Async.await(client_wrapper[method:gsub('/', '_')](client_wrapper, params)) end
                    )
                )
            end
        end

        local all_results = Async.await(Async.all(tasks))

        ctx.queue(function()
            local results = {}
            for _, result in ipairs(all_results) do
                if result then
                    for _, location in ipairs(result) do
                        table.insert(results, location)
                    end
                end
            end

            if #results == 0 then
                ctx.item({
                    display_text = 'No results found for "' .. word .. '"',
                    data = { error = true },
                })
                ctx.done()
                return
            end

            -- Sort results by filename and position
            table.sort(results, function(a, b)
                if a.uri ~= b.uri then return a.uri < b.uri end
                local a_range = a.range or a.targetSelectionRange
                local b_range = b.range or b.targetSelectionRange
                if a_range.start.line ~= b_range.start.line then return a_range.start.line < b_range.start.line end
                return a_range.start.character < b_range.start.character
            end)

            -- Process and display results
            for _, location in ipairs(results) do
                local uri = location.uri or location.targetUri
                local range = location.range or location.targetSelectionRange
                local filename = vim.uri_to_fname(uri)
                local short_filename = vim.fn.fnamemodify(filename, ':~:.')
                local line_content = get_line_content(filename, range.start.line)

                line_content = line_content:gsub('^%s*', ''):gsub('%s*$', '')
                if line_content == '' then line_content = '<empty line>' end

                local line_nr = range.start.line + 1
                local col_nr = range.start.character + 1
                local is_current = filename == current_filename
                    and line_nr == current_line
                    and math.abs(col_nr - current_col - 1) < 2

                -- Format: "short_filename (line_nr:column_nr): line_content"
                local prefix = string.format('%s (%d:%d): ', short_filename, line_nr, col_nr)
                local display_text = prefix .. line_content
                local content_offset = #prefix -- Position where actual content starts

                -- Get buffer number for the file
                local bufnr = vim.fn.bufnr(filename)
                -- If buffer doesn't exist, try adding it
                if bufnr == -1 then bufnr = vim.fn.bufadd(filename) end

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
                        -- Added fields for treesitter decorator
                        bufnr = bufnr,
                        lnum = line_nr, -- 1-indexed line number
                        text = line_content, -- Text content for highlighting
                        content_offset = content_offset, -- Position where content starts
                        prefix = prefix, -- The metadata prefix
                    },
                })

                ctx.done()
            end
        end)
    end)
end

local function fetch_diagnostics(ctx)
    local buf = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(buf)

    ctx.on_abort(function() clear_highlights(buf) end)

    -- Get all diagnostics for current buffer
    local diagnostics = vim.diagnostic.get(buf)

    -- Process diagnostics
    if #diagnostics == 0 then
        ctx.item({
            display_text = 'No diagnostics found in this buffer',
            data = { error = true },
        })
        ctx.done()
        return
    end

    -- Sort diagnostics by severity (most severe first)
    table.sort(
        diagnostics,
        function(a, b)
            return (a.severity or vim.diagnostic.severity.INFO) < (b.severity or vim.diagnostic.severity.INFO)
        end
    )

    -- Get severity names for display
    local severity_names = {
        [vim.diagnostic.severity.ERROR] = 'ERROR',
        [vim.diagnostic.severity.WARN] = 'WARN',
        [vim.diagnostic.severity.INFO] = 'INFO',
        [vim.diagnostic.severity.HINT] = 'HINT',
    }

    local bufnr = vim.fn.bufnr(filename)

    -- Process and display diagnostics
    for _, diagnostic in ipairs(diagnostics) do
        local range = {
            start = { line = diagnostic.lnum, character = diagnostic.col },
            ['end'] = {
                line = diagnostic.end_lnum or diagnostic.lnum,
                character = diagnostic.end_col or diagnostic.col + 1,
            },
        }
        local line_nr = diagnostic.lnum + 1
        local col_nr = diagnostic.col + 1
        local severity = diagnostic.severity or vim.diagnostic.severity.INFO
        local severity_name = severity_names[severity] or 'UNKNOWN'
        local message = diagnostic.message:gsub('\n', ' ')

        local line_content = get_line_content(filename, diagnostic.lnum)
        line_content = line_content:gsub('^%s*', ''):gsub('%s*$', '')
        if line_content == '' then line_content = '<empty line>' end

        -- Format: "short_filename (line_nr:column_nr - [SEVERITY]): message"
        local short_filename = vim.fn.fnamemodify(filename, ':~:.')
        local prefix = string.format('%s (%d:%d - [%s]): ', short_filename, line_nr, col_nr, severity_name)
        local display_text = prefix .. message

        ctx.item({
            display_text = display_text,
            filter_text = display_text .. ' ' .. line_content,
            data = {
                filename = filename,
                bufnr = bufnr,
                range = range,
                line_nr = line_nr,
                lnum = diagnostic.lnum + 1,
                col_nr = col_nr,
                message = message,
                severity = severity,
                severity_name = severity_name,
                line_content = line_content,
                text = line_content,
                prefix = prefix,
            },
        })
    end

    ctx.done()
end

local function fetch_symbols(ctx)
    local bufnr = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(bufnr)

    ctx.on_abort(function() clear_highlights(bufnr) end)

    return Async.run(function()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })

        if #clients == 0 then
            ctx.item({
                display_text = 'No LSP clients attached to this buffer',
                data = { error = true },
            })
            ctx.done()
            return
        end

        local tasks = {}

        for _, client in ipairs(clients) do
            if client.supports_method('textDocument/documentSymbol') then
                local client_wrapper = Client.new(client)
                table.insert(
                    tasks,
                    Async.run(
                        function()
                            return Async.await(client_wrapper:textDocument_documentSymbol({
                                textDocument = { uri = vim.uri_from_bufnr(bufnr) },
                            }))
                        end
                    )
                )
            end
        end

        local all_results = Async.await(Async.all(tasks))

        ctx.queue(function()
            local symbols = {}
            for _, result in ipairs(all_results) do
                if result then
                    for _, symbol in ipairs(result) do
                        table.insert(symbols, symbol)
                    end
                end
            end

            if #symbols == 0 then
                ctx.item({
                    display_text = 'No symbols found in this document',
                    data = { error = true },
                })
                ctx.done()
                return
            end

            local flat_symbols = flatten_symbols(symbols)

            -- Sort symbols by position
            table.sort(flat_symbols, function(a, b)
                if a.range.start.line ~= b.range.start.line then return a.range.start.line < b.range.start.line end
                return a.range.start.character < b.range.start.character
            end)

            local symbol_kinds = {}

            for k, v in pairs(vim.lsp.protocol.SymbolKind) do
                --- Don't show @Package symbols
                if type(v) == 'number' and v ~= 4 then symbol_kinds[v] = k end
            end

            -- Process and display symbols
            for _, symbol in ipairs(flat_symbols) do
                local range = symbol.range
                local line_nr = range.start.line + 1
                local col_nr = range.start.character + 1
                local kind_name = symbol_kinds[symbol.kind] or 'Unknown'

                local line_content = get_line_content(filename, range.start.line)
                line_content = line_content:gsub('^%s*', ''):gsub('%s*$', '')

                if kind_name ~= 'Unknown' and line_content ~= '' then
                    -- Format: "short_filename (line_nr:column_nr - @lsp_symbol_name): line_content"
                    local short_filename = vim.fn.fnamemodify(filename, ':~:.')
                    local prefix = string.format('%s (%d:%d - @%s): ', short_filename, line_nr, col_nr, kind_name)
                    local display_text = prefix .. line_content
                    local content_offset = #prefix

                    ctx.item({
                        display_text = display_text,
                        filter_text = display_text,
                        data = {
                            filename = filename,
                            bufnr = vim.fn.bufnr(filename),
                            range = range,
                            line_nr = line_nr,
                            lnum = range.start.line + 1,
                            col_nr = col_nr,
                            line_content = line_content,
                            text = line_content,
                            symbol_name = symbol.name,
                            symbol_kind = symbol.kind,
                            symbol_kind_name = kind_name,
                            content_offset = content_offset, -- Position where content starts
                            prefix = prefix, -- The metadata prefix
                        },
                    })
                end
            end

            ctx.done()
        end)
    end)
end

Utils.Group('crnvl96-deck-setup', function(g)
    vim.api.nvim_create_autocmd('User', {
        pattern = 'DeckStart',
        group = g,
        callback = function(e)
            local ctx = e.data.ctx

            ctx.keymap('n', '<Tab>', deck.action_mapping('choose_action'))
            ctx.keymap('n', '<C-l>', deck.action_mapping('refresh'))
            ctx.keymap('n', 'i', deck.action_mapping('prompt'))
            ctx.keymap('n', 'a', deck.action_mapping('prompt'))
            ctx.keymap('n', '@', deck.action_mapping('toggle_select'))
            ctx.keymap('n', '*', deck.action_mapping('toggle_select_all'))
            ctx.keymap('n', 'p', deck.action_mapping('toggle_preview_mode'))
            ctx.keymap('n', 'd', deck.action_mapping('delete'))
            ctx.keymap('n', '<CR>', deck.action_mapping('default'))
            ctx.keymap('n', 'o', deck.action_mapping('open'))
            ctx.keymap('n', 'O', deck.action_mapping('open_keep'))
            ctx.keymap('n', 's', deck.action_mapping('open_split'))
            ctx.keymap('n', 'v', deck.action_mapping('open_vsplit'))
            ctx.keymap('n', 'N', deck.action_mapping('create'))
            ctx.keymap('n', 'w', deck.action_mapping('write'))
            ctx.keymap('n', '<C-b>', deck.action_mapping('scroll_preview_up'))
            ctx.keymap('n', '<C-f>', deck.action_mapping('scroll_preview_down'))
            ctx.keymap('n', '<C-q>', deck.action_mapping('send_to_qf'))
        end,
    })

    vim.api.nvim_create_autocmd('User', {
        pattern = 'DeckStart:explorer',
        group = g,
        callback = function(e)
            local ctx = e.data.ctx
            ctx.keymap('n', 'h', deck.action_mapping('explorer.collapse'))
            ctx.keymap('n', 'l', deck.action_mapping('explorer.expand'))
            ctx.keymap('n', '.', deck.action_mapping('explorer.toggle_dotfiles'))
            ctx.keymap('n', 'c', deck.action_mapping('explorer.clipboard.save_copy'))
            ctx.keymap('n', 'm', deck.action_mapping('explorer.clipboard.save_move'))
            ctx.keymap('n', 'p', deck.action_mapping('explorer.clipboard.paste'))
            ctx.keymap('n', 'x', deck.action_mapping('explorer.clipboard.paste'))
            ctx.keymap('n', 'a', deck.action_mapping('explorer.create'))
            ctx.keymap('n', 'd', deck.action_mapping('explorer.delete'))
            ctx.keymap('n', 'r', deck.action_mapping('explorer.rename'))

            ctx.keymap('n', '<Leader>ff', deck.action_mapping('explorer.dirs'))

            ctx.keymap('n', 'P', deck.action_mapping('toggle_preview_mode'))
            ctx.keymap('n', '~', function() ctx.do_action('explorer.get_api').set_cwd(vim.fs.normalize('~')) end)
            ctx.keymap('n', '\\', function() ctx.do_action('explorer.get_api').set_cwd(vim.fs.normalize('/')) end)
            ctx.keymap('n', '%', function()
                local alt_buf = vim.fn.bufnr('#')
                local bufname = vim.fn.bufname(alt_buf)
                local bufdir = vim.fn.fnamemodify(bufname, ':p:h')
                ctx.do_action('explorer.get_api').set_cwd(bufdir)
            end)

            ctx.keymap('n', '<C-l>', function() vim.cmd('wincmd l') end)
            ctx.keymap('n', '-', function() ctx.dispose() end)
        end,
    })
end)

local function deck_resume()
    local context = deck.get_history()[vim.v.count == 0 and 1 or vim.v.count]
    if context then context.show() end
end

set('n', '-', '<Cmd>Deck explorer<CR>', { desc = 'File Explorer' })
set('n', '<Leader>fl', '<Cmd>Deck lines<CR>', { desc = 'Files' })
set('n', '<Leader>ff', '<Cmd>Deck files<CR>', { desc = 'Files' })
set('n', '<Leader>fg', '<Cmd>Deck grep<CR>', { desc = 'Grep' })
set('n', '<Leader>,', '<Cmd>Deck buffers<CR>', { desc = 'Buffers' })
set('n', '<Leader>fh', '<Cmd>Deck helpgrep<CR>', { desc = 'Help' })
set('n', '<Leader>fr', deck_resume, { desc = 'Resume last picker context' })

usercmd('DeckLspDefinition', function()
    deck.start({
        name = 'lsp_definitions',
        execute = function(ctx) return fetch_lsp(ctx, 'textDocument/definition') end,
        actions = { deck.alias_action('default', 'lsp_default_open_action') },
        previewers = { name = 'lsp_previewer' },
        decorators = { name = 'lsp_treesitter_decorator' },
    })
end, {})

usercmd('DeckLspReferences', function()
    deck.start({
        name = 'lsp_references',
        execute = function(ctx) return fetch_lsp(ctx, 'textDocument/references', true) end,
        actions = { deck.alias_action('default', 'lsp_default_open_action') },
        previewers = { name = 'lsp_previewer' },
        decorators = { name = 'lsp_treesitter_decorator' },
    })
end, {})

usercmd('DeckLspImplementation', function()
    deck.start({
        name = 'lsp_implementations',
        execute = function(ctx) return fetch_lsp(ctx, 'textDocument/implementation') end,
        actions = { deck.alias_action('default', 'lsp_default_open_action') },
        previewers = { name = 'lsp_previewer' },
        decorators = { name = 'lsp_treesitter_decorator' },
    })
end, {})

usercmd('DeckLspTypeDefinition', function()
    deck.start({
        name = 'lsp_type_definition',
        execute = function(ctx) return fetch_lsp(ctx, 'textDocument/typeDefinition') end,
        actions = { deck.alias_action('default', 'lsp_default_open_action') },
        previewers = { name = 'lsp_previewer' },
        decorators = { name = 'lsp_treesitter_decorator' },
    })
end, {})

usercmd('DeckLspDocumentSymbols', function()
    deck.start({
        name = 'lsp_document_symbols',
        execute = function(ctx) return fetch_symbols(ctx) end,
        actions = { deck.alias_action('default', 'lsp_default_open_action') },
        previewers = { name = 'lsp_previewer' },
        decorators = { name = 'lsp_treesitter_decorator' },
    })
end, {})

usercmd('DeckLspBufDiagnostics', function()
    deck.start({
        name = 'buf_diagnostics',
        execute = function(ctx) return fetch_diagnostics(ctx) end,
        actions = { deck.alias_action('default', 'lsp_default_open_action') },
        previewers = { name = 'lsp_previewer' },
        decorators = { name = 'lsp_regex_decorator' },
    })
end, {})
