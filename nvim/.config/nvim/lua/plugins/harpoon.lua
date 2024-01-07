return {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    branch = "harpoon2",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
    },
    opts = {},
    config = function(_, opts)
        require("harpoon"):setup(opts)
    end,
    -- stylua: ignore
    keys = {
        {"<m-m>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Toggle harpoon list" },
        {"<s-m>", function() require("harpoon"):list():append() end, desc = "Append to harpoon list" },
        {"<m-j>", function() require("harpoon"):list():select(1) end, desc = "Goto first item on harpoon list" },
        {"<m-k>", function() require("harpoon"):list():select(2) end, desc = "Goto second item on harpoon list" },
        {"<m-l>", function() require("harpoon"):list():select(3) end, desc = "Goto third item on harpoon list" },
        {"<m-;>", function() require("harpoon"):list():select(4) end, desc = "Goto forth item on harpoon list" },
    },
}
