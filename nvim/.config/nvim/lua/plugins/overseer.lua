local function open_and_close()
    local overseer = require("overseer")
    overseer.open({ enter = false })
    vim.defer_fn(function()
        if vim.bo.filetype ~= "OverseerList" then
            overseer.close()
        end
    end, 10 * 1000)
end

return {
    {
        "stevearc/overseer.nvim",
        opts = {
            -- Setup DAP later when lazy-loading the plugin.
            dap = false,
            task_list = {
                default_detail = 2,
                direction = "bottom",
                max_width = { 600, 0.7 },
                bindings = {
                    ["<C-b>"] = "ScrollOutputUp",
                    ["<C-f>"] = "ScrollOutputDown",
                    ["H"] = "IncreaseAllDetail",
                    ["L"] = "DecreaseAllDetail",
                    -- Disable mappings I don't use.
                    ["g?"] = false,
                    ["<C-l>"] = false,
                    ["<C-h>"] = false,
                    ["{"] = false,
                    ["}"] = false,
                },
            },
            templates = {
                "builtin",
                "typescript.start_dev",
            },
            form = {
                win_opts = { winblend = 0 },
            },
            confirm = {
                win_opts = { winblend = 5 },
            },
            task_win = {
                win_opts = { winblend = 5 },
            },
        },
        keys = {
            {
                "<leader>ot",
                "<cmd>OverseerToggle<cr>",
                desc = "Toggle task window",
            },
        },
    },
}
