return {
    "stevearc/overseer.nvim",
    init = function()
        local clue = require("mini.clue")
        clue.config.clues = vim.list_extend(clue.config.clues, {
            { mode = "n", keys = "<leader>o", desc = "+overseer" },
        })
    end,
    opts = {
        dap = false,
        templates = { "builtin", "user.run_file" },
        task_list = {
            default_detail = 2,
            direction = "bottom",
            max_width = { 600, 0.7 },
            bindings = {
                ["<C-b>"] = "ScrollOutputUp",
                ["<C-f>"] = "ScrollOutputDown",
                ["<M-p>"] = "TogglePreview",
                ["H"] = "DecreaseAllDetail",
                ["L"] = "IncreaseAllDetail",
                ["g?"] = false,
                ["<C-l>"] = false,
                ["<C-h>"] = false,
                ["{"] = false,
                ["}"] = false,
            },
        },
    },
    keys = {
        { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle task window" },
        { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run task" },
    },
}
