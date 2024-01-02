return {
    "jinh0/eyeliner.nvim",
    lazy = false,
    opts = {
        highlight_on_key = true,
        dim = true,
    },
    config = function(_, opts)
        -- vim.api.nvim_set_hl(0, "EyelinerPrimary", { bold = true, italic = true, underline = true })
        -- vim.api.nvim_set_hl(0, "EyelinerSecondary", { underline = false })
        require("eyeliner").setup(opts)
    end,
}
