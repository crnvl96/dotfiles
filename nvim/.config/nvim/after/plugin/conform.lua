--- Use binaries installed with asdf to feed nvim lsps and formatters
--- When necessary, use local bin directory for the same purpose
local asdf = vim.env.HOME .. '/.asdf/shims/'
local lbin = vim.env.HOME .. '/.local/bin/'

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.disable_autoformat = false

require('conform').setup({
    notify_on_error = true,
    formatters = {
        injected = { ignore_errors = true },
        stylua = { command = asdf .. 'stylua' },
        prettierd = { command = asdf .. 'prettierd' },
        biome = { command = asdf .. 'biome' },
        yamlfmt = { command = asdf .. 'yamlfmt' },
        ruff = { command = lbin .. 'ruff' },
        taplo = { command = asdf .. 'taplo' },
    },
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
        markdown = { 'injected' },
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
