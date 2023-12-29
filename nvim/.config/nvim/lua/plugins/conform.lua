return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        init = function()
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        opts = {
            notify_on_error = false,
            format_on_save = { timeout_ms = 1000, lsp_fallback = true },
            formatters_by_ft = {
                fish = { "fish_indent" },
                lua = { "stylua" },
                go = { "goimports", "gofumpt" },
                javascript = { "prettierd" },
                javascriptreact = { "prettierd" },
                typescript = { "prettierd" },
                typescriptreact = { "prettierd" },
            },
        },
    },
}
