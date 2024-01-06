return {
    {
        "stevearc/oil.nvim",
        lazy = false,
        opts = {
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
        keys = {
            { "<m-o>", "<cmd>Oil<cr>", desc = "Oil" },
        },
    },
}
