_G.Utils = {}

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.Build = function(params, cmd)
    local prefix = 'Building ' .. params.name
    vim.notify(prefix, 'INFO')

    local obj = vim.system(cmd, { cwd = params.path }):wait()
    local res = obj.code == 0 and (prefix .. ' done') or (prefix .. ' failed')
    local lvl = obj.code == 0 and 'INFO' or 'ERROR'

    vim.notify(res, lvl)
end

Utils.OnAttach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local s = vim.keymap.set
    s('n', 'E', function() vim.diagnostic.open_float({ border = 'rounded' }) end, { desc = 'Eval', buffer = bufnr })
    s('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { desc = 'Eval', buffer = bufnr })
    s('n', 'ga', function() vim.lsp.buf.code_action() end, { desc = 'Actions', buffer = bufnr })
    s('n', 'gn', function() vim.lsp.buf.rename() end, { desc = 'Rename', buffer = bufnr })

    s('n', 'ge', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer diagnostic', buffer = bufnr })
    s('n', 'gE', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostic', buffer = bufnr })
    s('n', 'gs', function() Snacks.picker.lsp_symbols() end, { desc = 'Symbols', buffer = bufnr })
    s('n', 'gS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Symbols', buffer = bufnr })
    s(
        'n',
        'gd',
        function()
            Snacks.picker.lsp_definitions({
                include_current = true,
                auto_confirm = false,
                jump = { reuse_win = false },
            })
        end,
        { desc = 'Definition', buffer = bufnr }
    )
    s(
        'n',
        'gD',
        function()
            Snacks.picker.lsp_declarations({
                include_current = true,
                auto_confirm = false,
                jump = { reuse_win = false },
            })
        end,
        { desc = 'Definition', buffer = bufnr }
    )
    s(
        'n',
        'gi',
        function()
            Snacks.picker.lsp_implementations({
                include_current = true,
                auto_confirm = false,
                jump = { reuse_win = false },
            })
        end,
        { desc = 'Impl', buffer = bufnr }
    )
    s(
        'n',
        'gr',
        function()
            Snacks.picker.lsp_references({ include_current = true, auto_confirm = false, jump = { reuse_win = false } })
        end,
        { desc = 'References', nowait = true, buffer = bufnr }
    )
    s(
        'n',
        'gy',
        function()
            Snacks.picker.lsp_type_definitions({
                include_current = true,
                auto_confirm = false,
                jump = { reuse_win = false },
            })
        end,
        { desc = 'Typedefs', buffer = bufnr }
    )
end

Utils.Palette = function()
    if vim.o.background == 'dark' then
        return {
            base00 = '#151515',
            base01 = '#202020',
            base02 = '#303030',
            base03 = '#505050',
            base04 = '#b0b0b0',
            base05 = '#d0d0d0',
            base06 = '#e0e0e0',
            base07 = '#f5f5f5',
            base08 = '#ac4142',
            base09 = '#d28445',
            base0A = '#f4bf75',
            base0B = '#90a959',
            base0C = '#75b5aa',
            base0D = '#6a9fb5',
            base0E = '#aa759f',
            base0F = '#8f5536',
        }
    else
        return {
            base00 = '#f5f5f5',
            base01 = '#e0e0e0',
            base02 = '#d0d0d0',
            base03 = '#b0b0b0',
            base04 = '#505050',
            base05 = '#303030',
            base06 = '#202020',
            base07 = '#151515',
            base08 = '#ac4142',
            base09 = '#d28445',
            base0A = '#f4bf75',
            base0B = '#90a959',
            base0C = '#75b5aa',
            base0D = '#6a9fb5',
            base0E = '#aa759f',
            base0F = '#8f5536',
        }
    end
end
