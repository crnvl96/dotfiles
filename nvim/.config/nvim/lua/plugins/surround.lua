return {
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {
            keymaps = {
                insert = false,
                insert_line = false,
                normal_line = false,
                normal_cur_line = false,
                visual_line = false,
                change_line = false,
                normal = "ys",
                normal_cur = "yss",
                visual = "S",
                delete = "ds",
                change = "cs",
            },
        },
        config = function(_, opts)
            require("nvim-surround").setup(opts)
        end,
    },
}
