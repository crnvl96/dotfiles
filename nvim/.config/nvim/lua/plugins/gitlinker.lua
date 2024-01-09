return {
    {
        "linrongbin16/gitlinker.nvim",
        opts = {},
        config = function(_, opts)
            require("gitlinker").setup(opts)
        end,
        keys = {
            { "<leader>gb", "<cmd>GitLink<cr>", desc = "Copy link to clipboard", mode = { "n", "x" } },
            { "<leader>gB", "<cmd>GitLink blame<cr>", desc = "Copy blame to clipboard", mode = { "n", "x" } },
        },
    },
}
