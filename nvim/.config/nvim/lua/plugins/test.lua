return {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
        { "antoinemadec/FixCursorHold.nvim" },
        { "nvim-neotest/neotest-plenary" },
        { "nvim-neotest/neotest-go" },
        { "nvim-neotest/neotest-jest" },
        { "nvim-neotest/neotest-vim-test" },
        { "vim-test/vim-test" },
    },
    config = function()
        local clue = require("mini.clue")
        clue.config.clues = vim.list_extend(clue.config.clues, {
            { mode = "n", keys = "<leader>t", desc = "+test" },
            { mode = "x", keys = "<leader>t", desc = "+test" },
        })

        local neotest_ns = vim.api.nvim_create_namespace("neotest")
        vim.diagnostic.config({
            virtual_text = {
                format = function(diagnostic)
                    local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
                    return message
                end,
            },
        }, neotest_ns)

        require("neotest").setup({
            adapters = {
                require("neotest-plenary"),
                require("neotest-go"),
                require("neotest-jest")({
                    jestCommand = "npm test --",
                    jestConfigFile = "custom.jest.config.ts",
                    env = { CI = true },
                    cwd = function() -- path
                        return vim.fn.getcwd()
                    end,
                }),
                require("neotest-vim-test")({ ignore_filetypes = { "go", "javascript", "typescript", "jsx", "tsx" } }),
            },
            status = { virtual_text = true },
            output = { open_on_run = true },
            quickfix = {
                open = function()
                    vim.cmd("copen")
                end,
            },
        })
    end,
        -- stylua: ignore
        keys = {
          { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
          { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files" },
          { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
          { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
          { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
          { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
          { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
        },
}
