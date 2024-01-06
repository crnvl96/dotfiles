return {
    "mfussenegger/nvim-dap",
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            keys = {
                {
                    "<leader>du",
                    function()
                        require("dapui").toggle()
                    end,
                    desc = "Dap UI",
                },
                {
                    "<leader>de",
                    function()
                        require("dapui").eval()
                        require("dapui").eval()
                    end,
                    desc = "Eval",
                    mode = { "n", "v" },
                },
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
            opts = { virt_text_pos = "eol" },
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
        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = "mason.nvim",
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                automatic_installation = true,
                handlers = {},
                ensure_installed = { "js", "delve" },
            },
        },
        {
            "leoluz/nvim-dap-go",
            opts = {},
        },
    },
    keys = {
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

        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
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

        dap.adapters["pwa-node"] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                -- 💀 Make sure to update this path to point to your installation
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
                    request = "launch",
                    name = "Debug Nest Framework (Nvim)",
                    program = "${workspaceFolder}/src/main.ts",
                    outFiles = {
                        "${workspaceFolder}/dist/**/*.js",
                    },
                    skipFiles = {
                        "${workspaceFolder}/node_modules/**/*.js",
                        "<node_internals>/**/*.js",
                    },
                    runtimeArgs = {
                        "--nolazy",
                        "-r",
                        "ts-node/register",
                        "-r",
                        "tsconfig-paths/register",
                    },
                    console = "integratedTerminal",
                    sourceMaps = true,
                    cwd = "${workspaceFolder}",
                },
            }
        end

        require("dap.ext.vscode").load_launchjs(nil, {
            ["pwa-node"] = { "typescript", "javascript" },
            ["go"] = { "go" },
        })
    end,
}
