return {
    {
        "stevearc/oil.nvim",
        lazy = false,
        opts = {
            delete_to_trash = true,
            lsp_rename_autosave = true,
            constrain_cursor = "name",
            keymaps = {
                ["<C-h>"] = false,
                ["<C-l>"] = false,
                ["<C-p>"] = false,
                ["g;"] = "actions.toggle_trash",
            },
            view_options = {
                show_hidden = true,
            },
            preview = {
                win_options = {
                    winblend = 100,
                },
            },
        },
        keys = {
            { "<M-o>", "<cmd>Oil<CR>" },
        },
    },
}
