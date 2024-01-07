return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 200
        end,
        opts = {
            icons = { separator = "-", group = "" },
            layout = { align = "center" },
        },
        config = function(_, opts)
            require("which-key").setup(opts)
            require("which-key").register({
                ["<leader>b"] = { name = "+buffers" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>o"] = { name = "+overseer" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>t"] = { name = "+tests" },
                ["<leader>w"] = { name = "+windows" },
            })
        end,
    },
}
