return {
    {
        "alexghergh/nvim-tmux-navigation",
        opts = {
            disable_when_zoomed = true,
        },
        config = function(_, opts)
            require("nvim-tmux-navigation").setup(opts)
        end,
        keys = {
            { "<c-h>", "<cmd>NvimTmuxNavigateLeft<cr>", desc = "Tmux navigate left" },
            { "<c-j>", "<cmd>NvimTmuxNavigateDown<cr>", desc = "Tmux navigate down" },
            { "<c-k>", "<cmd>NvimTmuxNavigateUp<cr>", desc = "Tmux navigate up" },
            { "<c-l>", "<cmd>NvimTmuxNavigateRight<cr>", desc = "Tmux navigate right" },
        },
    },
}
