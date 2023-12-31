return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
            -- stylua: ignore
            keys = {
                {"<leader>du", function() require("dapui").toggle() end, desc = "Dap UI",},
                {"<leader>de", function() require("dapui").eval() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" },},
            },
                opts = {
                    floating = { border = "rounded" },
                },
                config = function(_, opts)
                    local dap = require("dap")
                    local dapui = require("dapui")
                    dapui.setup(opts)
                    dap.listeners.after.event_initialized["dapui_config"] = function()
                        dapui.open({})
                    end
                end,
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                opts = {
                    virt_text_pos = "eol",
                },
                config = function(_, opts)
                    require("nvim-dap-virtual-text").setup(opts)
                end,
            },
            {
                "jbyuki/one-small-step-for-vimkind",
                keys = {
                -- stylua: ignore
                {"<leader>dl", function() require("osv").launch({ port = 8086 }) end, desc = "Launch Lua adapter",},
                },
                config = function()
                    require("dap").adapters.nlua = function(callback, config)
                        ---@diagnostic disable-next-line: undefined-field
                        callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
                    end
                    require("dap").configurations["lua"] = {
                        {
                            type = "nlua",
                            request = "attach",
                            name = "Attach to running Neovim instance",
                        },
                    }
                end,
            },
            {
                "jay-babu/mason-nvim-dap.nvim",
                dependencies = "mason.nvim",
                cmd = { "DapInstall", "DapUninstall" },
                opts = {
                    automatic_installation = true,
                    handlers = {},
                    ensure_installed = { "js", "delve" },
                },
                config = function(_, opts)
                    require("mason-nvim-dap").setup(opts)
                end,
            },
            {
                "leoluz/nvim-dap-go",
                opts = {},
                config = function(_, opts)
                    require("dap-go").setup(opts)
                end,
            },
        },
    -- stylua: ignore
    keys = {
        {"<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition",},
        {"<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint",},
        {"<leader>dc", function() require("dap").continue() end, desc = "Continue",},
        ---@diagnostic disable-next-line: undefined-global
        {"<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args",},
        {"<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor",},
        {"<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)",},
        {"<leader>di", function() require("dap").step_into() end, desc = "Step Into",},
        {"<leader>dj", function() require("dap").down() end, desc = "Down",},
        {"<leader>dk", function() require("dap").up() end, desc = "Up",},
        {"<leader>dl", function() require("dap").run_last() end, desc = "Run Last",},
        {"<leader>do", function() require("dap").step_out() end, desc = "Step Out",},
        {"<leader>dO", function() require("dap").step_over() end, desc = "Step Over",},
        {"<leader>dp", function() require("dap").pause() end, desc = "Pause",},
        {"<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL",},
        {"<leader>ds", function() require("dap").session() end, desc = "Session",},
        {"<leader>dt", function() require("dap").terminate() end, desc = "Terminate",},
        {"<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets",},
    },

        config = function()
            local dap = require("dap")

            vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
            require("overseer").patch_dap(true)
            require("dap.ext.vscode").json_decode = require("overseer.json").decode

            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        require("mason-registry").get_package("js-debug-adapter"):get_install_path() .. "/js-debug/src/dapDebugServer.js",
                        "${port}",
                    },
                },
            }

            for _, language in ipairs({ "typescript", "javascript" }) do
                dap.configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        name = "run start:dev",
                        request = "launch",
                        runtimeExecutable = "npm",
                        cwd = "${workspaceFolder}",
                        console = "integratedTerminal",
                        runtimeArgs = {
                            "run",
                            "start:dev",
                        },
                        skipFiles = {
                            "${workspaceFolder}/node_modules/*",
                            "<node_internals>/*",
                        },
                    },
                }
            end

            require("dap.ext.vscode").load_launchjs(nil, {
                ["pwa-node"] = { "typescript", "javascript" },
                ["go"] = { "go" },
            })
        end,
    },
}
