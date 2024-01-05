return {
    {
        "alexghergh/nvim-tmux-navigation",
        opts = {
            disable_when_zoomed = true,
        },
        keys = {
            { "<c-h>", "<cmd>NvimTmuxNavigateLeft<cr>" },
            { "<c-j>", "<cmd>NvimTmuxNavigateDown<cr>" },
            { "<c-k>", "<cmd>NvimTmuxNavigateUp<cr>" },
            { "<c-l>", "<cmd>NvimTmuxNavigateRight<cr>" },
        },
    },
}
