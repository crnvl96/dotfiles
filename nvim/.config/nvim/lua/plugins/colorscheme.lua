return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        priority = 1000,
        enabled = true,
        init = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme kanagawa-dragon")
        end,
        opts = {
            compile = true,
            transparent = true,
            commentStyle = { italic = true },
            functionStyle = { bold = true },
            keywordStyle = { italic = true },
            statementStyle = { bold = true },
            typeStyle = {},
            colors = {
                theme = {
                    all = {
                        ui = {
                            bg_gutter = "none",
                            float = {
                                bg = "none",
                            },
                        },
                    },
                },
            },
            overrides = function(colors)
                local theme = colors.theme
                return {
                    String = { italic = true },

                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },

                    NormalFloat = { bg = "none" },
                    FloatBorder = { bg = "none" },
                    FloatTitle = { bg = "none" },
                }
            end,
        },
        config = function(_, opts)
            require("kanagawa").setup(opts)
        end,
    },
}
