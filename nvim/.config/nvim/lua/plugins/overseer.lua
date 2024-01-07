return {
    {
        "stevearc/overseer.nvim",
        init = function()
            vim.opt.grepprg = "rg --vimgrep --smart-case"
            vim.api.nvim_create_user_command("OverseerRestartLast", function()
                local tasks = require("overseer").list_tasks({ recent_first = true })
                if vim.tbl_isempty(tasks) then
                    vim.notify("No tasks found", vim.log.levels.WARN)
                else
                    require("overseer").run_action(tasks[1], "restart")
                end
            end, {})
            vim.api.nvim_create_user_command("Grep", function(params)
                local cmd, num_subs = vim.o.grepprg:gsub("%$%*", params.args)
                if num_subs == 0 then
                    cmd = cmd .. " " .. params.args
                end
                local task = require("overseer").new_task({
                    cmd = vim.fn.expandcmd(cmd),
                    components = {
                        {
                            "on_output_quickfix",
                            errorformat = vim.o.grepformat,
                            open = not params.bang,
                            open_height = 8,
                            items_only = true,
                        },
                        -- We don't care to keep this around as long as most tasks
                        { "on_complete_dispose", timeout = 30 },
                        "default",
                    },
                })
                task:start()
            end, { nargs = "*", bang = true, complete = "file" })
        end,
        opts = {
            dap = false,
            task_list = {
                default_detail = 2,
                direction = "bottom",
                max_width = { 600, 0.7 },
                bindings = {
                    ["<C-b>"] = "ScrollOutputUp",
                    ["<C-f>"] = "ScrollOutputDown",
                    ["H"] = "DecreaseAllDetail",
                    ["L"] = "IncreaseAllDetail",
                    ["g?"] = false,
                    ["<C-l>"] = false,
                    ["<C-h>"] = false,
                    ["{"] = false,
                    ["}"] = false,
                },
            },
            templates = {
                "builtin",
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
        config = function(_, opts)
            require("overseer").setup(opts)
        end,
        keys = {
            { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer toggle" },
            { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run a task from a template" },
            { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Task builder" },
            { "<leader>oL", "<cmd>OverseerRestartLast<cr>", desc = "Rerun last task" },
            { "<leader>os", "<cmd>OverseerSaveBundle <cr>", desc = "Save bundle" },
            { "<leader>ol", "<cmd>OverseerLoadBundle <cr>", desc = "Load bundle" },
            { "<leader>od", "<cmd>OverseerDeleteBundle <cr>", desc = "Delete bundle" },
        },
    },
}
