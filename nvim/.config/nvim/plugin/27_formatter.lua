Add({ source = 'stevearc/conform.nvim' })

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

require('conform').setup({
    notify_on_error = true,
    formatters = { injected = { ignore_errors = true } },
    formatters_by_ft = {
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
        lua = { 'stylua' },
        css = { 'prettierd' },
        html = { 'prettierd' },
        scss = { 'prettierd' },
        json = { 'prettierd' },
        jsonc = { 'prettierd' },
        yaml = { 'yamlfmt' },
        yml = { 'yamlfmt' },
        toml = { 'taplo' },
        markdown = { 'prettierd', 'injected' },
        python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
        typescript = function(bufnr)
            if bufnr and vim.fs.root(bufnr, { 'biome.json', 'biome.jsonc' }) then
                return { 'biome', 'biome-check', 'biome-organize-imports' }
            else
                return { 'prettierd' }
            end
        end,
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 3000, lsp_format = 'fallback' }
    end,
})
