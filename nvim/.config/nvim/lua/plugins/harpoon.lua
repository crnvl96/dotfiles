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
        vim.keymap.set("n", "<s-m>", function()
            harpoon:list():append()
        end, { desc = "Append to harpoon list", silent = true })
        vim.keymap.set("n", "<m-m>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Toggle harpoon list", silent = true })

        vim.keymap.set("n", "<m-j>", function()
            harpoon:list():select(1)
        end, { desc = "Goto first item on harpoon list", silent = true })
        vim.keymap.set("n", "<m-k>", function()
            harpoon:list():select(2)
        end, { desc = "Goto second item on harpoon list", silent = true })
        vim.keymap.set("n", "<m-l>", function()
            harpoon:list():select(3)
        end, { desc = "Goto third item on harpoon list", silent = true })
        vim.keymap.set("n", "<m-;>", function()
            harpoon:list():select(4)
        end, { desc = "Goto fourth item on harpoon list", silent = true })
    end,
}
