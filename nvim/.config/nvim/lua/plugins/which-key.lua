return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 200
    end,
    opts = {
        icons = {
            separator = "-",
            group = "",
        },
        layout = {
            align = "center",
        },
    },
    config = function(_, opts)
        local wk = require("which-key")

        wk.setup(opts)

        wk.register({
            ["<leader>f"] = { name = "+file" },
            ["<leader>s"] = { name = "+search" },
            ["<leader>c"] = { name = "+code" },
            ["<leader>g"] = { name = "+git" },
            ["<leader>b"] = { name = "+buffers" },
            ["<leader>w"] = { name = "+windows" },
        })
    end,
}
