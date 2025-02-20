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
    -- Formatting is handled by `stevearc/conform.nvim`
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    require('which-key').add({
        { '<Leader>l', group = 'LSP' },
        {
            mode = 'n',
            buffer = bufnr,
            { 'E', function() vim.diagnostic.open_float({ border = 'rounded' }) end, desc = 'Eval' },
            { 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, desc = 'Eval' },
            { '<Leader>la', function() vim.lsp.buf.code_action() end, desc = 'Actions' },
            { '<Leader>ln', function() vim.lsp.buf.rename() end, desc = 'Rename' },
            { '<Leader>le', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer diagnostic' },
            { '<Leader>lE', function() Snacks.picker.diagnostics() end, desc = 'Diagnostic' },
            { '<Leader>ls', function() Snacks.picker.lsp_symbols() end, desc = 'Symbols' },
            { '<Leader>lS', function() Snacks.picker.lsp_workspace_symbols() end, desc = 'Symbols' },
            { '<Leader>ld', function() Snacks.picker.lsp_definitions() end, desc = 'Definition' },
            { '<Leader>lD', function() Snacks.picker.lsp_declarations() end, desc = 'Definition' },
            { '<Leader>li', function() Snacks.picker.lsp_implementations() end, desc = 'Impl' },
            { '<Leader>ly', function() Snacks.picker.lsp_type_definitions() end, desc = 'Typedefs' },
            { '<Leader>lr', function() Snacks.picker.lsp_references() end, desc = 'References', nowait = true },
        },
    })
end
