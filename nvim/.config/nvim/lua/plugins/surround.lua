return {
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert = false,
                    insert_line = false,
                    normal_line = false,
                    normal_cur_line = false,
                    visual_line = false,
                    change_line = false,
                    delete = "gzd",
                    change = "gzc",
                    visual = "gzv",
                    normal = "gza",
                    normal_cur = "gzz",
                },
            })
        end,
    },
}
