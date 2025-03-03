_G.Utils = {}

Utils.Group = function(name, fn) fn(vim.api.nvim_create_augroup(name, { clear = true })) end

Utils.OnAttach = function(client, bufnr)
    -- Formatting is handled by `stevearc/conform.nvim`
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false

    local set = vim.keymap.set
    set('n', 'E', function() vim.diagnostic.open_float({ border = 'rounded' }) end, { desc = 'Eval', buffer = bufnr })
    set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { desc = 'Eval', buffer = bufnr })
    set('n', '<Leader>la', function() vim.lsp.buf.code_action() end, { desc = 'Actions', buffer = bufnr })
    set('n', '<Leader>ln', function() vim.lsp.buf.rename() end, { desc = 'Rename', buffer = bufnr })
    set('n', '<Leader>le', function() vim.diagnostic.setqflist() end, { desc = 'Diagnostics', buffer = bufnr })
    set('n', '<Leader>ls', function() vim.lsp.buf.document_symbol() end, { desc = 'Document Symbols', buffer = bufnr })
    set('n', '<Leader>lS', function() vim.lsp.buf.workdspace_symbol() end, { desc = 'Wksp Symbols', buffer = bufnr })
    set('n', '<Leader>ld', function() vim.lsp.buf.definition() end, { desc = 'Definition', buffer = bufnr })
    set('n', '<Leader>lD', function() vim.lsp.buf.declaration() end, { desc = 'Declaration', buffer = bufnr })
    set('n', '<Leader>li', function() vim.lsp.buf.implementation() end, { desc = 'Impl', buffer = bufnr })
    set('n', '<Leader>ly', function() vim.lsp.buf.type_definition() end, { desc = 'Typedefs', buffer = bufnr })
    set('n', '<Leader>lr', function() vim.lsp.buf.references() end, { desc = 'References', buffer = bufnr })
end
