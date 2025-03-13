local show_handler = vim.diagnostic.handlers.virtual_text.show
local hide_handler = vim.diagnostic.handlers.virtual_text.hide

assert(show_handler)

vim.diagnostic.config({
    float = { border = 'rounded', source = true },
    virtual_text = true,
    update_in_insert = true,
    virtual_lines = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN] = 'W',
            [vim.diagnostic.severity.HINT] = 'H',
            [vim.diagnostic.severity.INFO] = 'I',
        },
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
            [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
            [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
        },
    },
})

vim.diagnostic.handlers.virtual_text = {
    show = function(ns, bufnr, diagnostics, opts)
        table.sort(diagnostics, function(diag1, diag2) return diag1.severity > diag2.severity end)
        return show_handler(ns, bufnr, diagnostics, opts)
    end,
    hide = hide_handler,
}
