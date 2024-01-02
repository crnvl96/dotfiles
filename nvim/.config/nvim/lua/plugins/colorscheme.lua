return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        enabled = true,
        opts = {
            groups = {
                background = "#151515",
                background_nc = "#151515",
            },
            highlight_groups = {
                StatusLine = { fg = "love", bg = "love", blend = 10 },
                StatusLineNC = { fg = "subtle", bg = "surface" },
                CursorLine = { bg = "overlay", blend = 50 },
                Visual = { bg = "#26233a", blend = 50 },
                MatchParen = { fg = "gold", bg = "#151515" },
                LspReferenceText = { bg = "pine", blend = 50 },
                LspReferenceRead = { bg = "pine", blend = 50 },
                LspReferenceWrite = { bg = "pine", blend = 50 },
            },
        },
        config = function(_, opts)
            vim.opt.background = "dark"
            require("rose-pine").setup(opts)
            vim.cmd("colorscheme rose-pine")
        end,
    },
}
