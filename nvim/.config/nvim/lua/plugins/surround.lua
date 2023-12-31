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
                    delete = "dz",
                    change = "cz",
                    visual = "Z",
                    normal = "yz",
                    normal_cur = "yzz",
                },
            })

            local clue = require("mini.clue")
            clue.config.triggers = vim.list_extend(clue.config.triggers, {
                { mode = "n", keys = "y" },
                { mode = "n", keys = "d" },
                { mode = "n", keys = "c" },
            })
        end,
    },
}
