return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            { "vim-test/vim-test" },
            { "nvim-neotest/neotest-go" },
            { "nvim-neotest/neotest-vim-test" },
        },
        init = function()
            local neotest_ns = vim.api.nvim_create_namespace("neotest")
            vim.diagnostic.config({
                virtual_text = {
                    format = function(diagnostic)
                        -- Replace newline and tab characters with space for more compact diagnostics
                        local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                        return message
                    end,
                },
            }, neotest_ns)
        end,
        opts = function()
            return {
                status = { virtual_text = true },
                output = { open_on_run = true },
                adapters = {
                    require("neotest-go")({
                        experimental = {
                            test_table = true,
                        },
                    }),
                    require("neotest-vim-test")({ ignore_filetypes = { "go" } }),
                },
                quickfix = {
                    open = function()
                        vim.cmd("copen")
                    end,
                },
            }
        end,
        config = function(_, opts)
            require("neotest").setup(opts)
        end,
        -- stylua: ignore
        keys = {
            {"<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
            {"<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run all test files" },
            {"<leader>tr", function() require("neotest").run.run() end, desc = "Run nearest" },
            {"<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
            {"<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show output" },
            {"<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
            {"<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
        },
    },
}
