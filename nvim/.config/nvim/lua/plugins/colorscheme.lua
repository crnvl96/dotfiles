return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        enabled = true,
        init = function()
            vim.opt.background = "dark"
            vim.cmd("colorscheme rose-pine")
        end,
    },
}
