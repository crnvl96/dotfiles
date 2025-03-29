--- Use binaries installed with asdf to feed nvim lsps and formatters
--- When necessary, use local bin directory for the same purpose
-- local asdf = vim.env.HOME .. '/.asdf/shims/'
local asdf_node = vim.env.HOME .. '/.asdf/installs/nodejs/22.14.0/bin/'
local asdf_rust = vim.env.HOME .. '/.asdf/installs/rust/1.84.1/bin/'
local asdf_go = vim.env.HOME .. '/.asdf/installs/golang/1.23.5/bin/'
local lbin = vim.env.HOME .. '/.local/bin/'

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
vim.g.disable_autoformat = false

require('conform').setup({
    notify_on_error = true,
    formatters = {
        injected = { ignore_errors = true },
        stylua = { command = asdf_rust .. 'stylua' },
        prettierd = { command = asdf_node .. 'prettierd' },
        biome = { command = asdf_node .. 'biome' },
        yamlfmt = { command = asdf_go .. 'yamlfmt' },
        ruff = { command = lbin .. 'ruff' },
        taplo = { command = asdf_rust .. 'taplo' },
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
