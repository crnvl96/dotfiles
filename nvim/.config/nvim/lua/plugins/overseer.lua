return {
    {
        "stevearc/overseer.nvim",
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
                    -- Disable mappings I don't use.
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
    },
}
