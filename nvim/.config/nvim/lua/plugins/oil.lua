return {
    {
        "stevearc/oil.nvim",
        lazy = false,
        opts = {
            buf_options = {
                buflisted = false,
                bufhidden = "hide",
            },
            delete_to_trash = true,
            lsp_rename_autosave = true,
            constrain_cursor = "name",
            keymaps = {
                ["<c-h>"] = false,
                ["<c-l>"] = false,
                ["<c-p>"] = false,
                ["g;"] = "actions.toggle_trash",
            },
            view_options = {
                show_hidden = true,
            },
            preview = {
                win_options = {
                    winblend = 0,
                },
            },
        },
        config = function(_, opts)
            require("oil").setup(opts)
        end,
        keys = {
            { "<m-o>", "<cmd>Oil<cr>", desc = "Oil" },
        },
    },
}
