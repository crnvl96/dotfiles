return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
    },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()
    end,
    keys = function()
        local harpoon = require("harpoon")
        return {
            {
                "<m-m>",
                function()
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Toggle harpoon list",
            },
            {
                "<s-m>",
                function()
                    harpoon:list():append()
                end,
                desc = "Append to harpoon list",
            },
            {
                "<m-j>",
                function()
                    harpoon:list():select(1)
                end,
                desc = "Goto first item on harpoon list",
            },
            {
                "<m-k>",
                function()
                    harpoon:list():select(2)
                end,
                desc = "Goto second item on harpoon list",
            },
            {
                "<m-l>",
                function()
                    harpoon:list():select(3)
                end,
                desc = "Goto third item on harpoon list",
            },
            {
                "<m-;>",
                function()
                    harpoon:list():select(4)
                end,
                desc = "Goto forth item on harpoon list",
            },
        }
    end,
}
