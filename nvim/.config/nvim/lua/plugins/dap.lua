return {
    "mfussenegger/nvim-dap",
    dependencies = {
        { "leoluz/nvim-dap-go" },
        { "theHamsta/nvim-dap-virtual-text" },
        { "microsoft/vscode-js-debug", build = "npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out" },
        { "mxsdev/nvim-dap-vscode-js" },
        { "rcarriga/nvim-dap-ui" },
        { "jbyuki/one-small-step-for-vimkind" },
    },
    -- stylua: ignore
    keys = {
        {"<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition"},
        {"<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint"},
        {"<leader>dc", function() require("dap").continue() end, desc = "Continue"},
        ---@diagnostic disable-next-line: undefined-global
        {"<leader>da", function() require("dap").continue({before = get_args}) end, desc = "Run with Args"},
        {"<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor"},
        {"<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)"},
        {"<leader>di", function() require("dap").step_into() end, desc = "Step Into"},
        {"<leader>dj", function() require("dap").down() end, desc = "Down"},
        {"<leader>dk", function() require("dap").up() end, desc = "Up"},
        {"<leader>dl", function() require("dap").run_last() end, desc = "Run Last"},
        {"<leader>do", function() require("dap").step_out() end, desc = "Step Out"},
        {"<leader>dO", function() require("dap").step_over() end, desc = "Step Over"},
        {"<leader>dp", function() require("dap").pause() end, desc = "Pause"},
        {"<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL"},
        {"<leader>ds", function() require("dap").session() end, desc = "Session"},
        {"<leader>dt", function() require("dap").terminate() end, desc = "Terminate"},

        -- dapui
        {"<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets"},
        {"<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI"},
        {"<leader>de", function() require("dapui").eval() require("dapui").eval() end, desc = "Evaluate expression", mode = {"n", "v"}},

        -- Lua adapter
        {"<leader>dl", function() require("osv").launch({port = 8086}) end, desc = "Launch Lua adapter"},
        {"<leader>dn", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug nearest (other langs)"},

    },
    config = function()
        require("dap-go").setup()
        require("nvim-dap-virtual-text").setup({ virt_text_pos = "eol" })
        require("dap-vscode-js").setup({
            debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
            adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
        })

        require("overseer").patch_dap(true)
        require("dap.ext.vscode").json_decode = require("overseer.json").decode

        require("dapui").setup()
        require("dap").listeners.after.event_initialized["dapui_config"] = function()
            require("dapui").open()
        end

        require("dap").adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
        require("dap").configurations["lua"] = {
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
            },
        }

        require("dap.ext.vscode").load_launchjs(nil, {
            ["pwa-node"] = { "typescript", "javascript" },
        })
    end,
}
