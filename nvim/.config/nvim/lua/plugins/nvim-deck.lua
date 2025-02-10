Add('hrsh7th/nvim-deck')

local deck = require('deck')

local severity = { 'ERROR', 'WARN' }

local icons = {
    [vim.diagnostic.severity.ERROR] = 'E',
    [vim.diagnostic.severity.WARN] = 'W',
    [vim.diagnostic.severity.HINT] = 'H',
    [vim.diagnostic.severity.INFO] = 'I',
}

local hls = {
    [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
    [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
    [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
    [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
}

local function get_buf_diagnostics(bufnr)
    local diag = vim.diagnostic.get(bufnr, severity)

    table.sort(diag, function(a, b) return a.severity < b.severity end)

    return diag
end

local function show_buf_diagnostics()
    local bufnr = vim.api.nvim_get_current_buf()
    local diags = get_buf_diagnostics(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)

    if not diags or #diags == 0 then
        vim.print('No diagnostics for this buffer.')
        return
    end

    deck.start({
        name = 'buffer diagnostics',
        execute = function(ctx)
            local bufname = vim.fn.fnamemodify(filename, ':t')

            for _, diag in ipairs(diags) do
                ctx.item({
                    data = {
                        filename = filename,
                        bufname = bufname,
                        bufnr = diag.bufnr,
                        lnum = diag.lnum + 1,
                        col = diag.col,
                        diagnostics = diag,
                    },
                    display_text = {
                        { ('(%s:%s): %s'):format(diag.lnum + 1, diag.col + 1, diag.message) },
                    },
                })
            end
            ctx.done()
        end,
        actions = {
            require('deck').alias_action('default', 'open'),
        },
    })
end

require('deck').register_decorator({
    name = 'diagnostics',
    resolve = function(_, item) return item.data.diagnostics end,
    decorate = function(_, item, row)
        local bufname = item.data.bufname
        local icon = icons[item.data.diagnostics.severity]
        local hl = hls[item.data.diagnostics.severity]
        return {
            {
                row = row,
                col = 0,
                virt_text = { { '  ' .. icon .. '  ', hl } },
                virt_text_pos = 'inline',
            },
            {
                row = row,
                col = 0,
                virt_text = { { bufname, 'Comment' } },
                virt_text_pos = 'right_align',
            },
        }
    end,
})

local function get_all_keymaps()
    local maps = {}
    local modes = { 'n', 'i', 'v', 'x', 'o' }

    for _, mode in ipairs(modes) do
        local mode_maps = vim.api.nvim_get_keymap(mode)
        for _, map in ipairs(mode_maps) do
            local lhs = map.lhs
            if lhs ~= nil and lhs:sub(1, 1) == ' ' then lhs = '<Leader>' .. lhs:sub(2) end

            map['display_text'] = string.format(
                '%s | %s → %s %s',
                mode,
                lhs,
                map.rhs or '',
                map.desc and ('(' .. map.desc .. ')') or ''
            )
            table.insert(maps, map)
        end
    end

    local bufnr = vim.api.nvim_get_current_buf()
    for _, mode in ipairs(modes) do
        local buf_maps = vim.api.nvim_buf_get_keymap(bufnr, mode)
        for _, map in ipairs(buf_maps) do
            local lhs = map.lhs
            if lhs ~= nil and lhs:sub(1, 1) == ' ' then lhs = '<Leader>' .. lhs:sub(2) end

            map['display_text'] = string.format(
                '%s | %s → %s %s (buffer)',
                mode,
                lhs,
                map.rhs or '',
                map.desc and ('(' .. map.desc .. ')') or ''
            )
            table.insert(maps, map)
        end
    end

    return maps
end

local function show_keymap_picker()
    local ok, _ = pcall(require, 'deck')
    if not ok then
        vim.notify('nvim-deck is not installed', vim.log.levels.ERROR)
        return
    end

    local maps = get_all_keymaps()

    deck.start({
        name = 'Mappings',
        execute = function(ctx)
            for _, map in ipairs(maps) do
                ctx.item(map)
            end
            ctx.done()
        end,
        actions = {
            {
                name = 'default',
                resolve = function(ctx)
                    local is_resolve = #ctx.get_action_items() == 1 and ctx.get_action_items()[1].lhs
                    return is_resolve
                end,
                execute = function(ctx)
                    ctx.hide()
                    local lhs = ctx.get_action_items()[1].lhs
                    local keys = vim.api.nvim_replace_termcodes(lhs, true, true, true)
                    vim.api.nvim_feedkeys(keys, 'm', false)
                end,
            },
        },
    })
end

require('deck').register_action({
    name = 'to_qf',
    desc = 'Send selected items to quickfix list',

    resolve = function(ctx)
        local items = ctx.get_selected_items()
        local valid_items = vim.tbl_filter(function(item) return item.data and item.data.filename ~= nil end, items)
        return #valid_items > 0
    end,

    execute = function(ctx)
        local items = ctx.get_selected_items()

        local qf_items = vim.tbl_map(
            function(item)
                return {
                    filename = item.data.filename,
                    lnum = item.data.lnum or 1,
                    col = item.data.col or 1,
                    text = item.display_text,
                }
            end,
            items
        )

        vim.fn.setqflist(qf_items)

        vim.cmd('copen')
        ctx.hide()
    end,
})

local function create_lsp_references_source()
    return {
        name = 'lsp_references',
        dynamic = false,
        execute = function(ctx)
            local bufnr = vim.api.nvim_get_current_buf()
            local params = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(bufnr))
            params.context = { includeDeclaration = true }

            local clients = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/references' })

            if #clients == 0 then
                vim.notify('No LSP clients support textDocument/references')
                ctx.done()
                return
            end

            clients[1].request('textDocument/references', params, function(_, result)
                if not result then
                    ctx.done()
                    return
                end

                for _, location in ipairs(result) do
                    local filename = vim.uri_to_fname(location.uri)
                    local range = location.range

                    local line_text = ''
                    local lines = vim.fn.readfile(filename)
                    if lines and #lines >= (range.start.line + 1) then
                        line_text = ' ' .. vim.trim(lines[range.start.line + 1])
                    end

                    ctx.item({
                        display_text = string.format(
                            '%s:%d:%d',
                            vim.fn.fnamemodify(filename, ':~:.'),
                            range.start.line + 1,
                            range.start.character + 1
                        ),
                        data = {
                            filename = filename,
                            lnum = range.start.line + 1,
                            col = range.start.character + 1,
                            text = line_text,
                        },
                    })
                end
                ctx.done()
            end, bufnr)
        end,
        actions = { require('deck').alias_action('default', 'open') },
        decorators = {
            {
                name = 'lsp_decorator',
                decorate = function(_, item, row)
                    local relfilename = vim.fn.fnamemodify(item.data.filename, ':~:.')
                    local filename = vim.fn.fnamemodify(item.data.filename, ':t')
                    local dirname = vim.fn.fnamemodify(relfilename, ':r')
                    return {
                        {
                            row = row,
                            virt_text = {
                                { dirname .. '/', 'Comment' },
                                { filename, 'Special' },
                                { ':' .. item.data.lnum .. ':' .. item.data.col, 'Number' },
                                { item.data.text, 'Normal' },
                            },
                            virt_text_pos = 'overlay',
                        },
                    }
                end,
            },
        },
    }
end

local function create_lsp_source(method, name)
    return {
        name = 'lsp_' .. name,
        dynamic = false,
        execute = function(ctx)
            local bufnr = vim.api.nvim_get_current_buf()
            local params = vim.lsp.util.make_position_params(0, vim.lsp.util._get_offset_encoding(bufnr))

            vim.lsp.buf_request_all(0, method, params, function(results)
                if not results or vim.tbl_isempty(results) then return ctx.done() end

                for _, result in pairs(results) do
                    if result.result then
                        local locations = vim.tbl_islist(result.result) and result.result or { result.result }

                        for _, location in ipairs(locations) do
                            local uri = location.uri or location.targetUri
                            local range = location.range or location.targetRange
                            local filename = vim.uri_to_fname(uri)

                            -- Get the line content if the file exists
                            local line_text = ''
                            local lines = vim.fn.readfile(filename)
                            if lines and #lines >= (range.start.line + 1) then
                                line_text = ' ' .. vim.trim(lines[range.start.line + 1])
                            end

                            ctx.item({
                                display_text = string.format(
                                    '%s:%d',
                                    vim.fn.fnamemodify(filename, ':~:.'),
                                    range.start.line + 1
                                ),
                                data = {
                                    filename = filename,
                                    lnum = range.start.line + 1,
                                    col = range.start.character + 1,
                                    text = line_text,
                                },
                            })
                        end
                    end
                end

                ctx.done()
            end)
        end,
        actions = {
            require('deck').alias_action('default', 'open'),
        },
        decorators = {
            {
                name = 'lsp_decorator',
                decorate = function(_, item, row)
                    local relfilename = vim.fn.fnamemodify(item.data.filename, ':~:.')
                    local filename = vim.fn.fnamemodify(item.data.filename, ':t')
                    local dirname = vim.fn.fnamemodify(relfilename, ':r')
                    return {
                        {
                            row = row,
                            virt_text = {
                                { dirname .. '/', 'Comment' },
                                { filename, 'Special' },
                                { ':' .. item.data.lnum .. ':' .. item.data.col, 'Number' },
                                { item.data.text, 'Normal' },
                            },
                            virt_text_pos = 'overlay',
                        },
                    }
                end,
            },
        },
    }
end

local sources = {
    definitions = create_lsp_source('textDocument/definition', 'definitions'),
    implementations = create_lsp_source('textDocument/implementation', 'implementations'),
    type_definitions = create_lsp_source('textDocument/typeDefinition', 'type_definitions'),
}

local function show_lsp_source(source, display_name)
    return function() deck.start(source, { name = 'LSP ' .. display_name }) end
end

local function show_references() deck.start(create_lsp_references_source(), { name = 'LSP References' }) end

vim.api.nvim_create_autocmd('User', {
    pattern = 'DeckStart',
    callback = function(e)
        local ctx = e.data.ctx
        ctx.keymap('n', '<Esc>', function() ctx.set_preview_mode(false) end)
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
        ctx.keymap('n', '<C-u>', deck.action_mapping('scroll_preview_up'))
        ctx.keymap('n', '<C-d>', deck.action_mapping('scroll_preview_down'))

        ctx.keymap('n', 'Q', deck.action_mapping('to_qf'))
    end,
})

Later(function()
    vim.keymap.set(
        'n',
        '<Leader>f',
        function()
            deck.start(require('deck.builtin.source.files')({
                root_dir = vim.fn.getcwd(),
                ignore_globs = { '**/node_modules/', '**/.git/' },
            }))
        end,
        { desc = 'Files' }
    )

    vim.keymap.set(
        'n',
        '<Leader>g',
        function()
            deck.start(require('deck.builtin.source.grep')({
                root_dir = vim.fn.getcwd(),
                ignore_globs = { '**/node_modules/', '**/.git/' },
            }))
        end,
        { desc = 'Start grep search' }
    )

    vim.keymap.set(
        'n',
        '<Leader>/',
        function()
            deck.start(require('deck.builtin.source.lines')({
                bufnrs = { vim.api.nvim_get_current_buf() },
            }))
        end,
        { desc = 'Start grep search' }
    )

    vim.keymap.set(
        'n',
        '<Leader>b',
        function()
            deck.start(require('deck.builtin.source.buffers')({
                ignore_paths = { vim.fn.expand('%:p'):gsub('/$', '') },
                nofile = false,
            }))
        end,
        { desc = 'Show buffers' }
    )

    vim.keymap.set(
        'n',
        '<Leader>h',
        function() deck.start(require('deck.builtin.source.helpgrep')()) end,
        { desc = 'Live grep all help tags' }
    )

    vim.keymap.set('n', '<leader>k', function() show_keymap_picker() end, { desc = 'Keymaps' })

    vim.keymap.set('n', 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Actions' })
    vim.keymap.set('n', 'gn', function() vim.lsp.buf.rename() end, { desc = 'Rename' })
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { desc = 'Eval' })
    vim.keymap.set('n', 'E', function() vim.diagnostic.open_float({ border = 'rounded' }) end, { desc = 'Eval Error' })
    vim.keymap.set('i', '<C-/>', function() vim.lsp.buf.signature_help({ border = 'rounded' }) end, { desc = 'Help' })

    -- stylua: ignore start
    vim.keymap.set('n', 'gd', show_lsp_source(sources.definitions, 'Definitions'), { desc = 'Show LSP definitions' })
    vim.keymap.set('n', 'gD', function() show_buf_diagnostics() end, { desc = 'Show buffer diagnostics' })
    vim.keymap.set('n', 'gi', show_lsp_source(sources.implementations, 'Implementations'), { desc = 'Show LSP implementations' })
    vim.keymap.set('n', 'gy', show_lsp_source(sources.type_definitions, 'Type Definitions'), { desc = 'Show LSP type definitions' })
    vim.keymap.set('n', 'gr', show_references, { noremap = true, silent = true, nowait = true })
    -- stylua: ignore end

    -- Show the latest deck context.
    vim.keymap.set('n', '<Leader>;', function()
        local ctx = require('deck').get_history()[1]
        if ctx then ctx.show() end
    end)
end)
