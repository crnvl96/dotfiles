return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            config = function()
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup()
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end
            end,
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = { virt_text_pos = "eol" },
        },
        {
            "mxsdev/nvim-dap-vscode-js",
            opts = {
                debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
                adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
            },
        },
        {
            "microsoft/vscode-js-debug",
            build = "npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out",
        },
        {
            "leoluz/nvim-dap-go",
            opts = {},
        },
        {
            "jbyuki/one-small-step-for-vimkind",
            keys = {
                {
                    "<leader>dl",
                    function()
                        require("osv").launch({ port = 8086 })
                    end,
                    desc = "Launch Lua adapter",
                },
            },
        },
    },
    keys = {
        {
            "<leader>du",
            function()
                require("dapui").toggle({})
            end,
            desc = "Dap UI",
        },
        {
            "<leader>de",
            function()
                -- Calling this twice to open and jump into the window.
                require("dapui").eval()
                require("dapui").eval()
            end,
            desc = "Evaluate expression",
            mode = { "n", "v" },
        },
        {
            "<leader>dB",
            function()
                require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
            end,
            desc = "Breakpoint Condition",
        },
        {
            "<leader>db",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Toggle Breakpoint",
        },
        {
            "<leader>dc",
            function()
                require("dap").continue()
            end,
            desc = "Continue",
        },
        {
            "<leader>da",
            function()
                ---@diagnostic disable-next-line: undefined-global
                require("dap").continue({ before = get_args })
            end,
            desc = "Run with Args",
        },
        {
            "<leader>dC",
            function()
                require("dap").run_to_cursor()
            end,
            desc = "Run to Cursor",
        },
        {
            "<leader>dg",
            function()
                require("dap").goto_()
            end,
            desc = "Go to line (no execute)",
        },
        {
            "<leader>di",
            function()
                require("dap").step_into()
            end,
            desc = "Step Into",
        },
        {
            "<leader>dj",
            function()
                require("dap").down()
            end,
            desc = "Down",
        },
        {
            "<leader>dk",
            function()
                require("dap").up()
            end,
            desc = "Up",
        },
        {
            "<leader>dl",
            function()
                require("dap").run_last()
            end,
            desc = "Run Last",
        },
        {
            "<leader>do",
            function()
                require("dap").step_out()
            end,
            desc = "Step Out",
        },
        {
            "<leader>dO",
            function()
                require("dap").step_over()
            end,
            desc = "Step Over",
        },
        {
            "<leader>dp",
            function()
                require("dap").pause()
            end,
            desc = "Pause",
        },
        {
            "<leader>dr",
            function()
                require("dap").repl.toggle()
            end,
            desc = "Toggle REPL",
        },
        {
            "<leader>ds",
            function()
                require("dap").session()
            end,
            desc = "Session",
        },
        {
            "<leader>dt",
            function()
                require("dap").terminate()
            end,
            desc = "Terminate",
        },
        {
            "<leader>dw",
            function()
                require("dap.ui.widgets").hover()
            end,
            desc = "Widgets",
        },
    },
    config = function()
        local dap = require("dap")

        require("overseer").patch_dap(true)
        require("dap.ext.vscode").json_decode = require("overseer.json").decode

        dap.adapters.nlua = function(callback, config)
            callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
        dap.configurations["lua"] = {
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
